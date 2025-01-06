// Hàm định dạng số

 export const formatNumber = (num) => {
    if (isNaN(num)) return num; // Kiểm tra nếu không phải là số
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }