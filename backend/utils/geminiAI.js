const axios = require('axios');
const dotenv = require('dotenv');

dotenv.config();

/**
 * Utility class for interacting with Google's Gemini AI API
 */
class GeminiAI {
  constructor() {
    this.apiKey = process.env.GEMINI_API_KEY;
    this.apiUrl = process.env.GEMINI_API_URL;
  }

  /**
   * Generate a response from Gemini AI
   * @param {string} prompt - The prompt to send to the AI
   * @param {object} options - Additional options for the request
   * @returns {Promise<object>} - The AI response
   */
  async generateResponse(prompt, options = {}) {
    try {
      const url = `${this.apiUrl}?key=${this.apiKey}`;
      
      const requestBody = {
        contents: [
          {
            parts: [
              {
                text: prompt
              }
            ]
          }
        ],
        generationConfig: {
          temperature: options.temperature || 0.7,
          topK: options.topK || 40,
          topP: options.topP || 0.95,
          maxOutputTokens: options.maxTokens || 1024,
        }
      };

      const response = await axios.post(url, requestBody, {
        headers: {
          'Content-Type': 'application/json'
        }
      });

      return {
        success: true,
        data: response.data,
        text: response.data.candidates[0].content.parts[0].text
      };
    } catch (error) {
      console.error('Gemini AI Error:', error.response?.data || error.message);
      return {
        success: false,
        error: error.response?.data || error.message
      };
    }
  }

  /**
   * Generate task prioritization advice
   * @param {Array} tasks - Array of tasks to prioritize
   * @returns {Promise<object>} - Prioritized tasks with reasons
   */
  async prioritizeTasks(tasks) {
    const prompt = `
      I need help prioritizing these tasks. Please analyze them and return a JSON array of prioritized tasks with reasons.
      Consider deadlines, tags (especially 'Urgent'), and priority levels.
      
      Tasks: ${JSON.stringify(tasks)}
      
      Return the response in this JSON format:
      {
        "prioritizedTasks": [
          {
            "id": "task_id",
            "priority": "high/medium/low",
            "reason": "Explanation for this priority"
          }
        ]
      }
    `;

    const response = await this.generateResponse(prompt);
    
    if (!response.success) {
      throw new Error('Failed to prioritize tasks with Gemini AI');
    }

    try {
      // Extract JSON from the response text
      const jsonMatch = response.text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        return JSON.parse(jsonMatch[0]);
      } else {
        throw new Error('Could not extract JSON from Gemini response');
      }
    } catch (error) {
      console.error('Error parsing Gemini response:', error);
      throw new Error('Failed to parse Gemini AI response');
    }
  }

  /**
   * Generate time estimate for a task
   * @param {object} task - Task details
   * @param {Array} pastTasks - Past tasks for context
   * @returns {Promise<string>} - Estimated time
   */
  async estimateTaskTime(task, pastTasks = []) {
    const prompt = `
      Please suggest a time estimate for this task:
      Title: ${task.title}
      Description: ${task.description || 'N/A'}
      Tags: ${task.tags ? task.tags.join(', ') : 'N/A'}
      
      ${pastTasks.length > 0 ? `Here are some past tasks with time estimates for context: ${JSON.stringify(pastTasks)}` : ''}
      
      Return the response in this JSON format:
      {
        "estimatedTime": "2 hours"
      }
    `;

    const response = await this.generateResponse(prompt);
    
    if (!response.success) {
      throw new Error('Failed to estimate task time with Gemini AI');
    }

    try {
      // Extract JSON from the response text
      const jsonMatch = response.text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        return JSON.parse(jsonMatch[0]);
      } else {
        throw new Error('Could not extract JSON from Gemini response');
      }
    } catch (error) {
      console.error('Error parsing Gemini response:', error);
      throw new Error('Failed to parse Gemini AI response');
    }
  }

  /**
   * Rewrite a vague task to be more specific
   * @param {object} task - Task to rewrite
   * @returns {Promise<object>} - Rewritten task
   */
  async rewriteTask(task) {
    const prompt = `
      Please rewrite this task to make it more specific and actionable:
      Title: ${task.title}
      Description: ${task.description || ''}
      
      Return the response in this JSON format:
      {
        "rewrittenTitle": "More specific title",
        "rewrittenDescription": "More detailed and actionable description"
      }
    `;

    const response = await this.generateResponse(prompt);
    
    if (!response.success) {
      throw new Error('Failed to rewrite task with Gemini AI');
    }

    try {
      // Extract JSON from the response text
      const jsonMatch = response.text.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        return JSON.parse(jsonMatch[0]);
      } else {
        throw new Error('Could not extract JSON from Gemini response');
      }
    } catch (error) {
      console.error('Error parsing Gemini response:', error);
      throw new Error('Failed to parse Gemini AI response');
    }
  }
}

module.exports = GeminiAI;
