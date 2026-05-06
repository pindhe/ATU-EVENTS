from rest_framework import serializers
from .models import EventCategory, Event, UserEventInterest

class EventCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = EventCategory
        fields = '__all__'

class EventSerializer(serializers.ModelSerializer):
    created_by_username = serializers.ReadOnlyField(source='created_by.username')
    category_name = serializers.ReadOnlyField(source='category.name')
    department_name = serializers.ReadOnlyField(source='department.name')

    class Meta:
        model = Event
        fields = '__all__'
        read_only_fields = ['created_by']

class UserEventInterestSerializer(serializers.ModelSerializer):
    event_title = serializers.ReadOnlyField(source='event.title')

    class Meta:
        model = UserEventInterest
        fields = '__all__'
        read_only_fields = ['user']
