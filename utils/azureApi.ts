import axios from 'axios';

const AZURE_API_BASE_URL = "https://ai-graphitestorm8466ai385706727975.openai.azure.com";
const AZURE_API_KEY = "Ax80ppCsRf3baI69t4Ww7WdIgE2ywqwmoxVQk8WXiX5rN2Q6bYv0JQQJ99BCACHYHv6XJ3w3AAAAACOGTC2b";
const DEPLOYMENT_NAME = "gpt-35-turbo";
const API_VERSION = "2023-05-15";

const MAX_RETRIES = 3;
const INITIAL_RETRY_DELAY = 1000;

const processTaskBreakdown = (content: string): string[] => {
  let processedContent = content
    .replace(/^(here|let me|i'll|i will).*?(break|steps|step by step|instructions).*?\n/i, '')
    .replace(/^(here are|these are).*?(steps|instructions).*?\n/i, '');
  
  let steps = processedContent.split('\n')
    .map(step => step.trim())
    .filter(step => step.length > 0)
    .map(step => step.replace(/^(\d+\.|\*|\-)\s+/, ''));
  
  return steps;
};

const makeApiRequestWithRetry = async (messages: any[], maxTokens: number = 100): Promise<string[]> => {
  let retries = 0;
  let delay = INITIAL_RETRY_DELAY;
  
  while (true) {
    try {
      const response = await axios.post(
        `${AZURE_API_BASE_URL}/openai/deployments/${DEPLOYMENT_NAME}/chat/completions?api-version=${API_VERSION}`,
        {
          messages,
          max_tokens: maxTokens
        },
        {
          headers: {
            "Content-Type": "application/json",
            "api-key": AZURE_API_KEY
          }
        }
      );
      
      const rawContent = response.data.choices[0].message.content;
      return processTaskBreakdown(rawContent);
    } catch (error: any) {
      if (error.response && error.response.status === 429 && retries < MAX_RETRIES) {
        retries++;
        console.log(`Rate limited. Retrying in ${delay}ms... (Attempt ${retries}/${MAX_RETRIES})`);
        
        await new Promise(resolve => setTimeout(resolve, delay));
        
        delay *= 2;
      } else {
        if (error.response && error.response.status === 429) {
          throw new Error("API rate limit exceeded. Please try again later.");
        } else {
          throw error;
        }
      }
    }
  }
};

export const getTaskBreakdown = async (task: string): Promise<string[]> => {
  try {
    const messages = [
      { 
        role: "system", 
        content: "You are a task breakdown assistant. Respond ONLY with numbered steps. No introductions, explanations, or conclusions. Just the steps themselves."
      },
      { 
        role: "user", 
        content: `Break down this task for someone with ADHD into 3-4 simple, actionable steps: "${task}". 
        IMPORTANT: List ONLY the steps themselves. No introductory text like "Here's a breakdown" or explanations.` 
      }
    ];
    
    return await makeApiRequestWithRetry(messages);
  } catch (error) {
    console.error("Error fetching task breakdown:", error);
    throw error;
  }
};

export const simplifyStep = async (step: string): Promise<string[]> => {
  try {
    const messages = [
      { 
        role: "system", 
        content: "You are a task simplification assistant. Respond ONLY with the simplified steps. No introductions, explanations, or conclusions."
      },
      { 
        role: "user", 
        content: `Split this task into exactly 2 simpler, more manageable steps: "${step}". 
        IMPORTANT: Respond with ONLY the 2 steps. Each on a new line. No explanations or extra text.` 
      }
    ];
    
    const result = await makeApiRequestWithRetry(messages);
    return result.slice(0, 2);
  } catch (error) {
    console.error("Error simplifying step:", error);
    throw error;
  }
};
