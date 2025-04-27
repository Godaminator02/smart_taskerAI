const express = require('express');
const router = express.Router();
const {
  getPrioritizationAdvice,
  getTimeEstimateSuggestion,
  getTaskRewriteSuggestion,
} = require('../controllers/aiController');

// Route for getting AI prioritization advice
router.get('/prioritize', getPrioritizationAdvice);

// Route for getting AI time estimate suggestion
router.post('/suggest-time', getTimeEstimateSuggestion);

// Route for getting AI task rewrite suggestion
router.post('/rewrite-task', getTaskRewriteSuggestion);

module.exports = router;
