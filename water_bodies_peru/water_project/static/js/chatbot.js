// Chatbot functionality
let chatbotOpen = false;

function toggleChatbot() {
    const chatbotIframe = document.getElementById('chatbotIframe');
    const chatbotButton = document.getElementById('chatbotButton');
    
    chatbotOpen = !chatbotOpen;
    
    if (chatbotOpen) {
        chatbotIframe.classList.add('active');
        chatbotButton.style.transform = 'rotate(360deg)';
    } else {
        chatbotIframe.classList.remove('active');
        chatbotButton.style.transform = 'rotate(0deg)';
    }
}

// Cerrar chatbot al hacer clic fuera de él
document.addEventListener('click', function(event) {
    const chatbotContainer = document.querySelector('.chatbot-container');
    const chatbotIframe = document.getElementById('chatbotIframe');
    
    if (chatbotOpen && !chatbotContainer.contains(event.target)) {
        chatbotIframe.classList.remove('active');
        document.getElementById('chatbotButton').style.transform = 'rotate(0deg)';
        chatbotOpen = false;
    }
});

// Prevenir que el click dentro del chatbot cierre el chatbot
document.querySelector('.chatbot-container').addEventListener('click', function(event) {
    event.stopPropagation();
});
