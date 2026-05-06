from rest_framework import viewsets, permissions
from .models import EventCategory, Event, UserEventInterest
from .serializers import EventCategorySerializer, EventSerializer, UserEventInterestSerializer

class EventCategoryViewSet(viewsets.ModelViewSet):
    queryset = EventCategory.objects.all()
    serializer_class = EventCategorySerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

class EventViewSet(viewsets.ModelViewSet):
    queryset = Event.objects.all().order_by('-start_time')
    serializer_class = EventSerializer
    permission_classes = [permissions.IsAuthenticatedOrReadOnly]

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)

class UserEventInterestViewSet(viewsets.ModelViewSet):
    serializer_class = UserEventInterestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return UserEventInterest.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
