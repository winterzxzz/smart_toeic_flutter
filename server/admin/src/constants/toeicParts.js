export const TOEIC_PARTS = {
  1: {
    name: 'Photographs',
    type: 'listening',
    requirements: ['Audio file', 'Image file'],
    description: 'Four short statements about a photograph. Select the one that best describes the photograph.',
  },
  2: {
    name: 'Question-Response',
    type: 'listening',
    requirements: ['Audio file'],
    description: 'Three responses to one question. Select the best response.',
  },
  3: {
    name: 'Conversations',
    type: 'listening',
    requirements: ['Audio file', 'Optional image'],
    description: 'Listen to conversations and answer three questions for each.',
  },
  4: {
    name: 'Talks',
    type: 'listening',
    requirements: ['Audio file', 'Optional image'],
    description: 'Listen to talks and answer three questions for each.',
  },
  5: {
    name: 'Incomplete Sentences',
    type: 'reading',
    requirements: ['Text only'],
    description: 'Choose the word or phrase that best completes the sentence.',
  },
  6: {
    name: 'Text Completion',
    type: 'reading',
    requirements: ['Text only'],
    description: 'Choose the word or phrase that best completes the text.',
  },
  7: {
    name: 'Reading Comprehension',
    type: 'reading',
    requirements: ['Text passages', 'Optional images'],
    description: 'Read passages and answer questions about them.',
  },
}
