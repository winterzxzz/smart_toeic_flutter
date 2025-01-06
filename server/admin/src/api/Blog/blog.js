import { API_URL } from '../constantsAPI';

export const createBlogPost = async (postData) => {
    try {
        const response = await fetch(`${API_URL}/api/admin/blog`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(postData),
        });
        return await response.json();
    } catch (error) {
        console.error('Error creating blog post:', error);
        throw error;
    }
};
