import React from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createStackNavigator } from "@react-navigation/stack";
import TaskScreen from "./screens/TaskScreen";

const Stack = createStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Task Breakdown" component={TaskScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
