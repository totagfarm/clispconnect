import { View, Text, StyleSheet, TextInput, TouchableOpacity, Alert } from 'react-native'
import { useState } from 'react'
import * as Location from 'expo-location'
import AsyncStorage from '@react-native-async-storage/async-storage'

export default function Reports() {
  const [localProjects, setLocalProjects] = useState('')
  const [securityIncidents, setSecurityIncidents] = useState('')
  const [infrastructureNeeds, setInfrastructureNeeds] = useState('')
  const [isSubmitting, setIsSubmitting] = useState(false)

  const handleSubmit = async () => {
    setIsSubmitting(true)

    try {
      // Get current location
      const { status } = await Location.requestForegroundPermissionsAsync()
      let location = null
      
      if (status === 'granted') {
        const currentLocation = await Location.getCurrentPositionAsync({})
        location = {
          latitude: currentLocation.coords.latitude,
          longitude: currentLocation.coords.longitude,
        }
      }

      // Create report
      const report = {
        local_projects: localProjects,
        security_incidents: securityIncidents,
        infrastructure_needs: infrastructureNeeds,
        location: location,
        timestamp: new Date().toISOString(),
        is_synced: false,
      }

      // Save to local storage (offline-first)
      const existingReports = await AsyncStorage.getItem('pending_reports')
      const reports = existingReports ? JSON.parse(existingReports) : []
      reports.push(report)
      await AsyncStorage.setItem('pending_reports', JSON.stringify(reports))

      Alert.alert('Success', 'Report saved! Will sync when online.')
      
      // Clear form
      setLocalProjects('')
      setSecurityIncidents('')
      setInfrastructureNeeds('')
    } catch (error) {
      Alert.alert('Error', 'Failed to save report')
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <View style={styles.container}>
      <Text style={styles.title}>📝 Weekly Report</Text>

      <TextInput
        style={styles.input}
        placeholder="Local Project Updates"
        multiline
        numberOfLines={4}
        value={localProjects}
        onChangeText={setLocalProjects}
      />

      <TextInput
        style={styles.input}
        placeholder="Security Incidents"
        multiline
        numberOfLines={4}
        value={securityIncidents}
        onChangeText={setSecurityIncidents}
      />

      <TextInput
        style={styles.input}
        placeholder="Infrastructure Needs"
        multiline
        numberOfLines={4}
        value={infrastructureNeeds}
        onChangeText={setInfrastructureNeeds}
      />

      <TouchableOpacity
        style={[styles.submitButton, isSubmitting && styles.submitButtonDisabled]}
        onPress={handleSubmit}
        disabled={isSubmitting}
      >
        <Text style={styles.submitButtonText}>
          {isSubmitting ? 'Saving...' : 'Submit Report'}
        </Text>
      </TouchableOpacity>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1e5799',
    marginBottom: 20,
  },
  input: {
    backgroundColor: 'white',
    padding: 15,
    borderRadius: 8,
    marginBottom: 15,
    borderWidth: 1,
    borderColor: '#ddd',
    minHeight: 100,
  },
  submitButton: {
    backgroundColor: '#1e5799',
    padding: 15,
    borderRadius: 8,
    alignItems: 'center',
  },
  submitButtonDisabled: {
    opacity: 0.6,
  },
  submitButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 16,
  },
})