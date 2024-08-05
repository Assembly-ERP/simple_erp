// app/javascripts/preview.js
document.addEventListener("DOMContentLoaded", function() {
  const fileInput = document.querySelector('input[type="file"]');
  const previewContainer = document.getElementById('new-file-previews');

  if (fileInput) {
    fileInput.addEventListener('change', function(event) {
      previewContainer.innerHTML = ''; // Clear previous previews
      Array.from(event.target.files).forEach(file => {
        if (file.type.startsWith('image')) {
          const reader = new FileReader();
          reader.onload = function(e) {
            const img = document.createElement('img');
            img.src = e.target.result;
            img.style.maxWidth = '10vw';
            img.style.maxHeight = '10vh';
            img.style.marginBottom = '10px';
            previewContainer.appendChild(img);
          };
          reader.onerror = function(error) {
            console.error("Error loading file preview: ", error);
          };
          reader.readAsDataURL(file);
        }
      });
    });
  }

  
  const closeButtons = document.querySelectorAll('.close');
  closeButtons.forEach(button => {
    button.addEventListener('click', function() {
      const modal = this.closest('.modal');
      if (modal) {
        modal.style.display = 'none';
        const modalContent = modal.querySelector('.preview-modal');
        if (modalContent) {
          if (modalContent.tagName === 'IMG' || modalContent.tagName === 'IFRAME') {
            modalContent.src = '';
          }
        }
      }
    });
  });
});


export function openModal(imageSrc) {
  const modal = document.getElementById("imageModal");
  const modalImg = document.getElementById("modalImage");
  const spinner = document.getElementById("spinner");

  modal.style.display = "block";
  spinner.style.display = "block";
  modalImg.style.display = "none";

  modalImg.onload = function() {
    spinner.style.display = "none";
    modalImg.style.display = "block";
  };

  modalImg.src = imageSrc;
}

export function closeModal() {
  const modal = document.getElementById("imageModal");
  if (modal) {
    modal.style.display = "none";
  }
}

export function previewFile(event, fileUrl, contentType) {
  event.preventDefault();
  const modal = document.getElementById("fileModal");
  const modalFile = document.getElementById("modalFile");
  const spinner = document.getElementById("fileSpinner");

  modal.style.display = "block";
  spinner.style.display = "block";
  modalFile.style.display = "none";

  modalFile.onload = function() {
    spinner.style.display = "none";
    modalFile.style.display = "block";
  };

  modalFile.src = fileUrl;
}

export function closeModal() {
  const modal = document.getElementById("imageModal");
  if (modal) {
    modal.style.display = "none";
  }
}

export function closeFileModal() {
  const modal = document.getElementById("fileModal");
  if (modal) {
    modal.style.display = "none";
  }
}

let currentSlide = 0;
const slideWidth = 10; // Width of one image in vw (20vw for three images at a time, assuming each image takes 20vw)

function slideLeft() {
  const track = document.querySelector('.image-track');
  currentSlide = Math.max(currentSlide - 1, 0);
  track.style.transform = `translateX(-${currentSlide * slideWidth}vw)`;
}

function slideRight() {
  const track = document.querySelector('.image-track');
  const totalSlides = document.querySelectorAll('.image-preview').length;
  const maxSlides = totalSlides - 3; // Adjust this based on the number of visible images
  currentSlide = Math.min(currentSlide + 1, maxSlides);
  track.style.transform = `translateX(-${currentSlide * slideWidth}vw)`;
}