import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../styles/additional_window_theme.dart';
import '../../../providers/ui/search_provider.dart';
import 'package:eiga/ui/widgets/search/search_source_abstract.dart';
import 'package:eiga/ui/widgets/dialogs/app_bottom_sheet.dart';
import 'package:eiga/ui/widgets/upload/jimaku_files_sheet.dart';
import 'package:eiga/backend/database/dto/jimaku_dto.dart';
import 'package:eiga/ui/widgets/search/jimaku/jimaku_subtitle_source.dart';

class SearchPickerWidget<TEntry, TFile> extends ConsumerStatefulWidget {
  final SearchSource<TEntry, TFile> source;
  final void Function(String result) onResolved;
  final String? initialQuery;

  const SearchPickerWidget({
    super.key,
    required this.source,
    required this.onResolved,
    this.initialQuery,
  });

  @override
  ConsumerState<SearchPickerWidget<TEntry, TFile>> createState() =>
      _SearchPickerWidgetState<TEntry, TFile>();
}

class _SearchPickerWidgetState<TEntry, TFile>
    extends ConsumerState<SearchPickerWidget<TEntry, TFile>> {
  final _controller = TextEditingController();
  late final String _key = widget.source.key;
  Timer? _debounce;
  
  int _currentPage = 1;
  bool _isLoadingNextPage = false;
  bool _hasReachedEnd = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      // Sync local selection with global selection if exists
      final globalSelection = ref.read(selectedEntryProvider(_key));
      if (globalSelection != null) {
        ref.read(selectedResultProvider(_key).notifier).state = globalSelection;
      }

      final current = ref.read(searchFiltersProvider(_key));
      if (current.isEmpty) {
        ref.read(searchFiltersProvider(_key).notifier).state =
            Map.of(widget.source.defaultFilters);
      }
      if (widget.initialQuery != null && widget.initialQuery!.length >= 3) {
        _search(preserveSelection: true);
      }
    });

    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      final query = _controller.text.trim();
      if (query.length >= 3) {
        _search();
      }
    });
  }

  Future<void> _search({bool preserveSelection = false}) async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _currentPage = 1;
      _hasReachedEnd = false;
    });

    if (!preserveSelection) {
      ref.read(selectedEntryProvider(_key).notifier).state = null;
      ref.read(selectedResultProvider(_key).notifier).state = null;
    }
    
    ref.read(filesProvider(_key).notifier).state = [];
    ref.read(isSearchingProvider(_key).notifier).state = true;

    try {
      final filters = ref.read(searchFiltersProvider(_key));
      final results = await widget.source.search(query, filters, ref);
      ref.read(searchResultsProvider(_key).notifier).state = results;
      
      if (results.length < 10) {
         _hasReachedEnd = true;
      }
    } catch (e) {
      ref.read(searchResultsProvider(_key).notifier).state = [];
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Search error: $e')));
      }
    } finally {
      ref.read(isSearchingProvider(_key).notifier).state = false;
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingNextPage || _hasReachedEnd) return;

    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoadingNextPage = true;
    });

    try {
      final filters = ref.read(searchFiltersProvider(_key));
      final nextPage = _currentPage + 1;
      final results = await widget.source.fetchNextPage(query, nextPage, filters, ref);
      
      if (results.isEmpty) {
        _hasReachedEnd = true;
      } else {
        final currentResults = ref.read(searchResultsProvider(_key));
        ref.read(searchResultsProvider(_key).notifier).state = [...currentResults, ...results];
        _currentPage = nextPage;
        
        if (results.length < 10) {
          _hasReachedEnd = true;
        }
      }
    } catch (e) {
       // Silent fail for next page
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingNextPage = false;
        });
      }
    }
  }

  Future<void> _onEntryTap(TEntry entry) async {
    if (!widget.source.hasFileStage) {
      ref.read(selectedEntryProvider(_key).notifier).state = entry;
      ref.read(selectedResultProvider(_key).notifier).state = entry;
      
      // Start loading files in background to populate metadata/summary
      widget.source.getFiles(entry, {}, ref);
      return;
    }

    ref.read(selectedEntryProvider(_key).notifier).state = entry;
    ref.read(selectedResultProvider(_key).notifier).state = null;
    ref.read(filesProvider(_key).notifier).state = [];
    ref.read(isLoadingFilesProvider(_key).notifier).state = true;

    try {
      final filters = ref.read(searchFiltersProvider(_key));
      final files = await widget.source.getFiles(entry, filters, ref);
      ref.read(filesProvider(_key).notifier).state = files;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading details: $e')));
      }
    } finally {
      ref.read(isLoadingFilesProvider(_key).notifier).state = false;
    }
  }

  void _goBack() {
    ref.read(selectedEntryProvider(_key).notifier).state = null;
    ref.read(filesProvider(_key).notifier).state = [];
    ref.read(selectedResultProvider(_key).notifier).state = null;
  }

  Future<void> _confirm() async {
    final selected = ref.read(selectedResultProvider(_key));
    if (selected == null) return;

    ref.read(isResolvingProvider(_key).notifier).state = true;
    try {
      final result = await widget.source.resolve(selected, ref);
      widget.onResolved(result);

      if (mounted) Navigator.pop(context);

      ref.read(isResolvingProvider(_key).notifier).state = false;
    } catch (e) {
      if (mounted) {
        // Handle auto-select failure by closing silently or showing a hint
        if (e is JimakuAutoSelectException) {
          Navigator.pop(context); // Close search modal
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not auto-detect subtitles. Use "Advanced Settings" to pick manually.'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      ref.read(isResolvingProvider(_key).notifier).state = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildHeader(
      bool showDetails, TEntry? selectedEntry, AdditionalWindowTheme theme) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.backgroundColor.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: theme.handleColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (showDetails)
                      IconButton(
                        icon:
                            Icon(Icons.arrow_back, color: theme.selectionAccentColor),
                        onPressed: _goBack,
                      )
                    else
                      const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (showDetails)
                            Text(
                              widget.source.title,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: theme.mutedText,
                              ),
                            ),
                          Text(
                            showDetails
                                ? widget.source.entryLabel(selectedEntry as TEntry)
                                : widget.source.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: theme.titleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(Icons.close_rounded, size: 28, color: theme.normalText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchView(
      bool isSearching, List<TEntry> results, AdditionalWindowTheme theme, ScrollController scrollController, dynamic selectedResult) {
    
    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        _loadNextPage();
      }
    });

    return Column(
      key: const ValueKey('search-view'),
      children: [
        widget.source.buildFilterBar(context, ref),
        Expanded(
          child: ClipRect(
            child: results.isEmpty && !isSearching
                ? Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_rounded, size: 48, color: theme.mutedText.withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('Search for a title to see results',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: theme.mutedText, fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                : CustomScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.48,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final entry = results[index];
                              final bool isActive = selectedResult != null && 
                                  widget.source.entryId(entry) == widget.source.entryId(selectedResult as TEntry);
                              
                              return widget.source.buildEntryCard(
                                entry,
                                isActive,
                                () => _onEntryTap(entry),
                              );
                            },
                            childCount: results.length,
                          ),
                        ),
                      ),
                      if (_isLoadingNextPage)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: theme.primaryAccent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SliverToBoxAdapter(child: SizedBox(height: 40)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsView(
    TEntry entry,
    bool isLoadingFiles,
    List<TFile> files,
    dynamic selectedResult,
    AdditionalWindowTheme theme,
    ScrollController scrollController,
  ) {
    return Column(
      key: const ValueKey('details-view'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: widget.source.buildEntryCard(entry, true, _goBack),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Divider(height: 1, color: theme.dividerColor),
        ),
        Expanded(
          child: ClipRect(
            child: isLoadingFiles
                ? const Center(child: CircularProgressIndicator())
                : files.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Nothing found',
                            style: TextStyle(color: theme.mutedText)),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          return widget.source.buildFileCard(
                            file,
                            selectedResult != null &&
                                widget.source.fileId(file) ==
                                    widget.source.fileId(selectedResult as TFile),
                            () => ref
                                .read(selectedResultProvider(_key).notifier)
                                .state = file,
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider(_key)).cast<TEntry>();
    final selectedEntry = ref.watch(selectedEntryProvider(_key)) as TEntry?;
    final files = ref.watch(filesProvider(_key)).cast<TFile>();
    final selectedResult = ref.watch(selectedResultProvider(_key));
    final isSearching = ref.watch(isSearchingProvider(_key));
    final isLoadingFiles = ref.watch(isLoadingFilesProvider(_key));
    final isResolving = ref.watch(isResolvingProvider(_key));

    final theme = AdditionalWindowTheme.of(context);
    final showDetails = widget.source.hasFileStage && selectedEntry != null;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.98,
      expand: false,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: theme.backgroundColor.withValues(alpha: 0.88),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  _buildHeader(showDetails, selectedEntry, theme),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(
                                (child.key == const ValueKey('details-view'))
                                    ? 0.08
                                    : -0.08,
                                0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: showDetails
                          ? _buildDetailsView(
                              selectedEntry as TEntry,
                              isLoadingFiles,
                              files,
                              selectedResult,
                              theme,
                              scrollController,
                            )
                          : _buildSearchView(isSearching, results, theme, scrollController, selectedResult),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (selectedResult == null || isResolving)
                            ? null
                            : _confirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.addButtonBackground,
                          foregroundColor: theme.addButtonText,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: isResolving
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5, color: theme.addButtonText),
                              )
                            : const Text('OK',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
