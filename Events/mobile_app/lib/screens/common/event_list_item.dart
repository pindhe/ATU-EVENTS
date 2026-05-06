import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';

class EventListItem extends StatefulWidget {
  final Event event;
  final VoidCallback onTap;

  const EventListItem({Key? key, required this.event, required this.onTap}) : super(key: key);

  @override
  State<EventListItem> createState() => _EventListItemState();
}

class _EventListItemState extends State<EventListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFree = widget.event.price == null || widget.event.price == 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        transform: _isHovered ? (Matrix4.identity()..scale(1.02)) : Matrix4.identity(),
        child: Card(
          elevation: _isHovered ? 8 : 2,
          shadowColor: theme.colorScheme.primary.withOpacity(0.2),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'event-image-${widget.event.id}',
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: widget.event.imageUrl != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                child: widget.event.imageUrl!.startsWith('http')
                                    ? Image.network(widget.event.imageUrl!, fit: BoxFit.cover)
                                    : Image.asset('assets/placeholder.png', fit: BoxFit.cover), // Fallback for local
                              )
                            : Icon(Icons.event, size: 60, color: theme.colorScheme.primary),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: _buildLikeButton(context),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCategoryBadge(theme, widget.event.categoryName ?? 'General'),
                          Text(
                            isFree ? 'FREE' : '\$${widget.event.price!.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.event.title,
                        style: theme.textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_month, size: 16, color: theme.colorScheme.outline),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(widget.event.startTime),
                            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.location_on, size: 16, color: theme.colorScheme.outline),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.event.location,
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
      ),
      child: InkWell(
        onTap: () => eventProvider.toggleLike(widget.event.id),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.event.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: widget.event.isLiked ? Colors.red : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              widget.event.likeCount.toString(),
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(ThemeData theme, String label) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: theme.colorScheme.onSecondaryContainer,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
