const asyncHandler = require('express-async-handler');
const Task = require('../models/Task');
const GeminiAI = require('../utils/geminiAI');

// Helper function to format tasks for AI processing
const formatTasksForAI = (tasks) => {
  return tasks.map(task => ({
    id: task._id,
    title: task.title,
    description: task.description || '',
    deadline: task.deadline ? new Date(task.deadline).toISOString() : null,
    tags: task.tags || [],
    priority: task.priority,
    estimatedTime: task.estimatedTime || '',
    completed: task.completed,
    createdAt: task.createdAt,
  }));
};

// @desc    Get AI prioritization advice
// @route   GET /api/ai/prioritize
// @access  Public
const getPrioritizationAdvice = asyncHandler(async (req, res) => {
  // Get all incomplete tasks
  const tasks = await Task.find({ 
    completed: false
  });

  if (tasks.length === 0) {
    return res.json({ 
      message: "No tasks to prioritize",
      prioritizedTasks: [] 
    });
  }

  const formattedTasks = formatTasksForAI(tasks);

  try {
    // Use Gemini AI
    const geminiAI = new GeminiAI();
    const aiResponse = await geminiAI.prioritizeTasks(formattedTasks);
    
    res.json({
      message: "Tasks prioritized successfully",
      prioritizedTasks: aiResponse.prioritizedTasks || []
    });
  } catch (error) {
    console.error('AI API Error:', error.message);
    res.status(500);
    throw new Error('Error getting AI prioritization advice');
  }
});

// @desc    Get AI time estimate suggestion
// @route   POST /api/ai/suggest-time
// @access  Public
const getTimeEstimateSuggestion = asyncHandler(async (req, res) => {
  const { title, description, tags } = req.body;

  if (!title) {
    res.status(400);
    throw new Error('Please provide a task title');
  }

  // Get past tasks for context
  const pastTasks = await Task.find({ 
    estimatedTime: { $exists: true, $ne: '' }
  }).limit(5);

  const pastTasksFormatted = formatTasksForAI(pastTasks);

  try {
    // Use Gemini AI
    const geminiAI = new GeminiAI();
    const task = {
      title,
      description: description || '',
      tags: tags || []
    };
    
    const aiResponse = await geminiAI.estimateTaskTime(task, pastTasksFormatted);
    
    res.json({
      message: "Time estimate generated successfully",
      estimatedTime: aiResponse.estimatedTime || "Unable to estimate time"
    });
  } catch (error) {
    console.error('AI API Error:', error.message);
    res.status(500);
    throw new Error('Error getting AI time estimate suggestion');
  }
});

// @desc    Get AI task rewriting suggestion
// @route   POST /api/ai/rewrite-task
// @access  Public
const getTaskRewriteSuggestion = asyncHandler(async (req, res) => {
  const { title, description } = req.body;

  if (!title) {
    res.status(400);
    throw new Error('Please provide a task title');
  }

  try {
    // Use Gemini AI
    const geminiAI = new GeminiAI();
    const task = {
      title,
      description: description || ''
    };
    
    const aiResponse = await geminiAI.rewriteTask(task);
    
    res.json({
      message: "Task rewritten successfully",
      rewrittenTitle: aiResponse.rewrittenTitle || title,
      rewrittenDescription: aiResponse.rewrittenDescription || description
    });
  } catch (error) {
    console.error('AI API Error:', error.message);
    res.status(500);
    throw new Error('Error getting AI task rewrite suggestion');
  }
});

module.exports = {
  getPrioritizationAdvice,
  getTimeEstimateSuggestion,
  getTaskRewriteSuggestion,
};
