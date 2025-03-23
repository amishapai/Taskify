import React, { useState, useRef } from "react";
import { View, ScrollView, Animated, ActivityIndicator } from "react-native";
import { Card, Button, Text, Snackbar } from "react-native-paper";
import { getTaskBreakdown, simplifyStep } from "../utils/azureApi";

const TaskBreakdown = ({ task }: { task: string }) => {
  const [steps, setSteps] = useState<string[]>([]);
  const [completed, setCompleted] = useState<number[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [simplifyingIndex, setSimplifyingIndex] = useState<number | null>(null);
  const [error, setError] = useState<string | null>(null);

  const fadeAnims = useRef<Animated.Value[]>([]);

  const fetchSteps = async () => {
    setLoading(true);
    setError(null);

    try {
      const breakdown = await getTaskBreakdown(task);
      setSteps(breakdown);
      setCompleted([]);
      fadeAnims.current = breakdown.map(() => new Animated.Value(1));
    } catch (err: any) {
      setError(
        err.message || "Failed to generate task breakdown. Please try again."
      );
    } finally {
      setLoading(false);
    }
  };

  const markDone = (index: number) => {
    setCompleted([...completed, index]);

    Animated.timing(fadeAnims.current[index], {
      toValue: 0,
      duration: 500,
      useNativeDriver: true,
    }).start(() => {
      setSteps(steps.filter((_, i) => i !== index));

      fadeAnims.current = fadeAnims.current.filter((_, i) => i !== index);

      setCompleted(
        completed.filter((i) => i !== index).map((i) => (i > index ? i - 1 : i))
      );
    });
  };

  const simplifyTaskStep = async (index: number) => {
    const stepToSimplify = steps[index];
    setSimplifyingIndex(index);
    setError(null);

    try {
      const simplifiedSteps = await simplifyStep(stepToSimplify);

      if (simplifiedSteps.length === 2) {
        const newSteps = [...steps];
        newSteps.splice(index, 1, ...simplifiedSteps);
        setSteps(newSteps);

        const newFadeAnims = [...fadeAnims.current];
        newFadeAnims.splice(
          index,
          1,
          new Animated.Value(1),
          new Animated.Value(1)
        );
        fadeAnims.current = newFadeAnims;

        const newCompleted = completed
          .map((i) => (i === index ? -1 : i > index ? i + 1 : i))
          .filter((i) => i !== -1);
        setCompleted(newCompleted);
      }
    } catch (err: any) {
      setError(
        err.message || "Failed to simplify step. Please try again later."
      );
    } finally {
      setSimplifyingIndex(null);
    }
  };

  const dismissError = () => setError(null);

  return (
    <View style={{ flex: 1, padding: 10 }}>
      <Button
        mode="contained"
        onPress={fetchSteps}
        style={{ marginBottom: 10 }}
        disabled={loading}
      >
        {loading ? "Generating..." : "Generate Task Breakdown"}
      </Button>

      {loading && (
        <View style={{ padding: 20, alignItems: "center" }}>
          <ActivityIndicator size="large" color="#6200ee" />
          <Text style={{ marginTop: 10 }}>Generating task breakdown...</Text>
        </View>
      )}

      <ScrollView>
        {steps.map((step, index) => (
          <Animated.View
            key={index}
            style={{
              opacity: fadeAnims.current[index],
              marginVertical: 5,
            }}
          >
            <Card
              style={{
                backgroundColor: completed.includes(index)
                  ? "#B2FF59"
                  : "#FFECB3",
              }}
            >
              <Card.Content>
                <Text>{step}</Text>
              </Card.Content>
              <Card.Actions>
                <Button
                  mode="outlined"
                  disabled={
                    completed.includes(index) || simplifyingIndex !== null
                  }
                  onPress={() => markDone(index)}
                >
                  {completed.includes(index) ? "Done ✅" : "Mark as Done"}
                </Button>
                <Button
                  mode="text"
                  disabled={
                    completed.includes(index) || simplifyingIndex !== null
                  }
                  loading={simplifyingIndex === index}
                  onPress={() => simplifyTaskStep(index)}
                >
                  {simplifyingIndex === index
                    ? "Simplifying..."
                    : "Simplify More"}
                </Button>
              </Card.Actions>
            </Card>
          </Animated.View>
        ))}
      </ScrollView>

      <Snackbar
        visible={error !== null}
        onDismiss={dismissError}
        action={{
          label: "Dismiss",
          onPress: dismissError,
        }}
      >
        {error}
      </Snackbar>
    </View>
  );
};

export default TaskBreakdown;
