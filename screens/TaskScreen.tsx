import React, { useState } from "react";
import {
  SafeAreaView,
  TextInput,
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableWithoutFeedback,
  Keyboard,
  Platform,
} from "react-native";
import TaskBreakdown from "../components/TaskBreakdown";

const TaskScreen = () => {
  const [taskText, setTaskText] = useState("Write a research paper");

  const dismissKeyboard = () => {
    Keyboard.dismiss();
  };

  return (
    <TouchableWithoutFeedback onPress={dismissKeyboard}>
      <SafeAreaView style={{ flex: 1 }}>
        <View style={styles.container}>
          <View style={styles.inputContainer}>
            <Text style={styles.label}>Enter your task:</Text>
            <TextInput
              style={styles.input}
              value={taskText}
              onChangeText={setTaskText}
              placeholder="e.g., Write a research paper"
            />
          </View>

          <View style={styles.scrollContainer}>
            <ScrollView
              contentContainerStyle={styles.scrollContent}
              showsVerticalScrollIndicator={true}
              scrollEnabled={true}
              bounces={true}
              keyboardShouldPersistTaps="handled"
              alwaysBounceVertical={true}
              indicatorStyle="black" // Makes scroll indicator more visible on iOS
              persistentScrollbar={true} // Always show scroll bar on Android
            >
              <TaskBreakdown task={taskText} />
              <View style={styles.scrollPadding} />
            </ScrollView>
          </View>
        </View>
      </SafeAreaView>
    </TouchableWithoutFeedback>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#f5f5f5",
  },
  scrollContainer: {
    flex: 1,
    borderWidth: 1,
    borderColor: "#ddd",
    borderRadius: 8,
    marginHorizontal: 16,
    marginBottom: 16,
    backgroundColor: "#fff",
  },
  scrollContent: {
    padding: 16,
    flexGrow: 1,
  },
  inputContainer: {
    padding: 16,
    marginBottom: 8,
  },
  label: {
    fontSize: 16,
    fontWeight: "bold",
    marginBottom: 8,
  },
  input: {
    borderWidth: 1,
    borderColor: "#ccc",
    borderRadius: 4,
    padding: 12,
    fontSize: 16,
  },
  scrollPadding: {
    height: 100, // Add extra padding at the bottom
  },
});

export default TaskScreen;
