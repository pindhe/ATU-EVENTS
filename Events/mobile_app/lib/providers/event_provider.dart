import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/event.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];

  final List<String> _registeredEventIds = [];

  EventProvider() {
    _loadEvents();
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> eventList = _events.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('stored_events', eventList);
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? eventList = prefs.getStringList('stored_events');
    if (eventList != null && eventList.isNotEmpty) {
      _events = eventList.map((e) => Event.fromJson(jsonDecode(e))).toList();
      notifyListeners();
    }
  }

  List<Event> get allEvents => [..._events];
  
  List<Event> getVisibleEvents(String? studentClassId) {
    return _events.where((e) {
      if (!e.isPublished) return false;
      
      // Admin events are visible to everyone
      if (e.createdByUsername?.toLowerCase() == 'admin') return true;
      
      // Teacher events visibility
      if (e.visibility == EventVisibility.public) return true;
      if (e.visibility == EventVisibility.local && e.assignedClassId == studentClassId) return true;
      
      return false;
    }).toList();
  }

  List<Event> getEventsByTeacher(String username) {
    return _events.where((e) => e.createdByUsername == username).toList();
  }

  List<Event> get registeredEvents => _events.where((e) => _registeredEventIds.contains(e.id)).toList();

  bool isRegistered(String eventId) => _registeredEventIds.contains(eventId);

  void toggleRegistration(String eventId) {
    if (_registeredEventIds.contains(eventId)) {
      _registeredEventIds.remove(eventId);
    } else {
      _registeredEventIds.add(eventId);
    }
    notifyListeners();
  }

  void toggleLike(String eventId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index >= 0) {
      final e = _events[index];
      _events[index] = Event(
        id: e.id,
        title: e.title,
        description: e.description,
        startTime: e.startTime,
        endTime: e.endTime,
        location: e.location,
        imageUrl: e.imageUrl,
        categoryName: e.categoryName,
        createdByUsername: e.createdByUsername,
        isPublished: e.isPublished,
        visibility: e.visibility,
        assignedClassId: e.assignedClassId,
        maxParticipants: e.maxParticipants,
        currentParticipants: e.currentParticipants,
        price: e.price,
        isLiked: !e.isLiked,
        likeCount: e.isLiked ? e.likeCount - 1 : e.likeCount + 1,
      );
      _saveEvents();
      notifyListeners();
    }
  }

  void addEvent(Event event) {
    _events.add(event);
    _saveEvents();
    notifyListeners();
  }

  void updateEvent(String id, Event updatedEvent) {
    final index = _events.indexWhere((e) => e.id == id);
    if (index >= 0) {
      _events[index] = updatedEvent;
      _saveEvents();
      notifyListeners();
    }
  }

  void deleteEvent(String id) {
    _events.removeWhere((e) => e.id == id);
    _saveEvents();
    notifyListeners();
  }

  void bookTicket(String eventId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index >= 0) {
      final e = _events[index];
      if (e.maxParticipants == null || e.currentParticipants < e.maxParticipants!) {
        _events[index] = Event(
          id: e.id,
          title: e.title,
          description: e.description,
          startTime: e.startTime,
          endTime: e.endTime,
          location: e.location,
          imageUrl: e.imageUrl,
          categoryName: e.categoryName,
          createdByUsername: e.createdByUsername,
          isPublished: e.isPublished,
          visibility: e.visibility,
          assignedClassId: e.assignedClassId,
          maxParticipants: e.maxParticipants,
          currentParticipants: e.currentParticipants + 1,
          price: e.price,
          isLiked: e.isLiked,
          likeCount: e.likeCount,
        );
        _saveEvents();
        notifyListeners();
      }
    }
  }
}
