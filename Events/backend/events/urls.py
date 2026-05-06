from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import EventCategoryViewSet, EventViewSet, UserEventInterestViewSet

router = DefaultRouter()
router.register(r'categories', EventCategoryViewSet)
router.register(r'events', EventViewSet)
router.register(r'interests', UserEventInterestViewSet, basename='user-interests')

urlpatterns = [
    path('', include(router.urls)),
]
