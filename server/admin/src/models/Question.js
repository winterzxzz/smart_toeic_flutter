const mongoose = require('mongoose')

const QuestionSchema = new mongoose.Schema({
  part: {
    type: String,
    required: true
  },
  type: {
    type: String,
    enum: ['reading', 'listening'],
    required: true
  },
  questionType: {
    type: String,
    enum: ['text', 'image', 'audio'],
    required: true
  },
  content: {
    type: String,
    required: true
  },
  paragraph: String,
  answers: {
    A: String,
    B: String,
    C: String,
    D: String
  },
  correctAnswer: {
    type: String,
    required: true
  },
  audioUrl: String,
  audioStoragePath: String,
  imageUrl: String,
  imageStoragePath: String,
  createdAt: { 
    type: Date, 
    default: Date.now 
  },
  updatedAt: { 
    type: Date, 
    default: Date.now 
  }
})

// Middleware để tự động cập nhật updatedAt
QuestionSchema.pre('save', function(next) {
  this.updatedAt = Date.now()
  next()
})

module.exports = mongoose.model('Question', QuestionSchema)
