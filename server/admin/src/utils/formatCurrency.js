/**
 * Format a number to Vietnamese Dong (VNĐ) currency format.
 * @param {number} value - The number to format.
 * @returns {string} - The formatted currency string.
 */
export const formatCurrency = (value) => {
    if (isNaN(value)) {
      return '0 VND'; // Return '0 VNĐ' if the value is not a number
    }
    
    // Convert the number to a string and format it
    return value
      .toString()
      .replace(/\B(?=(\d{3})+(?!\d))/g, ".") + " VND"; // Add VNĐ at the end
  }