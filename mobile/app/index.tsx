import { View, Text, StyleSheet, TouchableOpacity } from 'react-native'
import { Link } from 'expo-router'
import { useState, useEffect } from 'react'
import * as Network from 'expo-network'

export default function Home() {
  const [isOnline, setIsOnline] = useState(true)

  useEffect(() => {
    checkNetwork()
  }, [])

  const checkNetwork = async () => {
    const state = await Network.getNetworkStateAsync()
    setIsOnline(state.isConnected ?? false)
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>🇱🇷 CLISPConnect</Text>
        <Text style={styles.subtitle}>Community Leadership Platform</Text>
      </View>

      {!isOnline && (
        <View style={styles.offlineBanner}>
          <Text style={styles.offlineText}>⚠️ Offline Mode - Reports will sync when online</Text>
        </View>
      )}

      <View style={styles.menu}>
        <Link href="/reports" style={styles.menuItem}>
          <Text style={styles.menuIcon}>📝</Text>
          <Text style={styles.menuText}>Submit Weekly Report</Text>
        </Link>

        <Link href="/profile" style={styles.menuItem}>
          <Text style={styles.menuIcon}>👤</Text>
          <Text style={styles.menuText}>My Profile</Text>
        </Link>

        <Link href="/training" style={styles.menuItem}>
          <Text style={styles.menuIcon}>📚</Text>
          <Text style={styles.menuText}>Training</Text>
        </Link>

        <Link href="/community" style={styles.menuItem}>
          <Text style={styles.menuIcon}>🏘️</Text>
          <Text style={styles.menuText}>My Community</Text>
        </Link>
      </View>

      <View style={styles.footer}>
        <Text style={styles.footerText}>CLEF - Ministry of Internal Affairs</Text>
        <Text style={styles.footerText}>Liberia 🇱🇷</Text>
      </View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1e5799',
    padding: 20,
  },
  header: {
    alignItems: 'center',
    marginBottom: 30,
    marginTop: 40,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: 'white',
    opacity: 0.9,
  },
  offlineBanner: {
    backgroundColor: '#FFA500',
    padding: 12,
    borderRadius: 8,
    marginBottom: 20,
  },
  offlineText: {
    color: 'white',
    fontWeight: '600',
    textAlign: 'center',
  },
  menu: {
    flex: 1,
    gap: 15,
  },
  menuItem: {
    backgroundColor: 'white',
    padding: 20,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 15,
  },
  menuIcon: {
    fontSize: 28,
  },
  menuText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1e5799',
  },
  footer: {
    alignItems: 'center',
    marginBottom: 20,
  },
  footerText: {
    color: 'white',
    opacity: 0.8,
    fontSize: 14,
  },
})