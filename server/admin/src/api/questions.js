const express = require('express')
const router = express.Router()
const Question = require('../models/Question')
const { uploadFile, deleteFile } = require('../services/firebase/storage')
const { API_URL } = require('../constantsAPI')

// Get all questions
router.get('/', async (req, res) => {
  try {
    const questions = await Question.find()
    res.json(questions)
  } catch (error) {
    res.status(500).json({ message: error.message })
  }
})

// Create question
router.post('/', async (req, res) => {
  try {
    const question = new Question(req.body)
    const savedQuestion = await question.save()
    res.status(201).json(savedQuestion)
  } catch (error) {
    res.status(400).json({ message: error.message })
  }
})

// Update question
router.put('/:id', async (req, res) => {
  try {
    const updatedQuestion = await Question.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedAt: Date.now() },
      { new: true }
    )
    res.json(updatedQuestion)
  } catch (error) {
    res.status(400).json({ message: error.message })
  }
})

// Delete question
router.delete('/:id', async (req, res) => {
  try {
    const question = await Question.findById(req.params.id)
    
    // Delete files from Firebase if they exist
    if (question.audioStoragePath) {
      await deleteFile(question.audioStoragePath)
    }
    if (question.imageStoragePath) {
      await deleteFile(question.imageStoragePath)
    }
    
    await question.remove()
    res.json({ message: 'Question deleted' })
  } catch (error) {
    res.status(500).json({ message: error.message })
  }
})

module.exports = router
