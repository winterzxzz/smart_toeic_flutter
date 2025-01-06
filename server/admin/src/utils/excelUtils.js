import * as XLSX from 'xlsx'

export const generateExcelTemplate = () => {
  const template = [
    {
      'Part': '',
      'Question Text': '',
      'Answer A': '',
      'Answer B': '',
      'Answer C': '',
      'Answer D': '',
      'Correct Answer': '',
      'Audio File URL': '',
      'Image URL': '',
    }
  ]

  const ws = XLSX.utils.json_to_sheet(template)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, 'TOEIC Questions')
  
  // Add column widths
  ws['!cols'] = [
    { wch: 10 }, // Part
    { wch: 40 }, // Question Text
    { wch: 30 }, // Answer A
    { wch: 30 }, // Answer B
    { wch: 30 }, // Answer C
    { wch: 30 }, // Answer D
    { wch: 15 }, // Correct Answer
    { wch: 50 }, // Audio URL
    { wch: 50 }, // Image URL
  ]

  return wb
}

export const exportToExcel = (questions) => {
  const data = questions.map(q => ({
    'Part': q.part,
    'Question Text': q.questionText,
    'Answer A': q.answers.A,
    'Answer B': q.answers.B,
    'Answer C': q.answers.C,
    'Answer D': q.answers.D,
    'Correct Answer': q.correctAnswer,
    'Audio File URL': q.audioFile ? 'Has Audio' : '',
    'Image URL': q.imageUrl || '',
  }))

  const ws = XLSX.utils.json_to_sheet(data)
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, 'TOEIC Questions')
  
  XLSX.writeFile(wb, 'toeic_questions.xlsx')
}

export const importFromExcel = async (file) => {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = (e) => {
      try {
        const data = new Uint8Array(e.target.result)
        const workbook = XLSX.read(data, { type: 'array' })
        const worksheet = workbook.Sheets[workbook.SheetNames[0]]
        const jsonData = XLSX.utils.sheet_to_json(worksheet)

        const questions = jsonData.map(row => ({
          id: Date.now() + Math.random(),
          part: row['Part'].toString(),
          questionText: row['Question Text'],
          answers: {
            A: row['Answer A'],
            B: row['Answer B'],
            C: row['Answer C'],
            D: row['Answer D'],
          },
          correctAnswer: row['Correct Answer'],
          audioFile: null,
          imageUrl: row['Image URL'] || null,
        }))

        resolve(questions)
      } catch (error) {
        reject(new Error('Error parsing Excel file: ' + error.message))
      }
    }
    reader.onerror = (error) => reject(error)
    reader.readAsArrayBuffer(file)
  })
} 