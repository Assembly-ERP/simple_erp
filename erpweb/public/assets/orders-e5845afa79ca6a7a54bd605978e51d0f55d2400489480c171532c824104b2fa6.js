// app/assets/javascripts/orders.js
document.addEventListener('DOMContentLoaded', function () {
    const filterSelect = document.getElementById('filter');
    const itemsList = document.getElementById('items_list');
    const itemModal = document.getElementById('item_modal');
    const previewModal = document.getElementById('preview_modal');
    const customerModal = document.getElementById('customer_modal');
  
    filterSelect.addEventListener('change', function () {
      const filterValue = filterSelect.value;
      if (filterValue === 'parts') {
        fetchParts();
      } else if (filterValue === 'products') {
        fetchProducts();
      }
    });
  
    itemsList.addEventListener('click', function (event) {
      if (event.target.classList.contains('item-details')) {
        const itemId = event.target.dataset.itemId;
        fetchItemDetails(itemId);
      }
    });
  
    document.getElementById('preview_order').addEventListener('click', function () {
      previewOrder();
    });
  
    document.getElementById('view_customer').addEventListener('click', function () {
      viewCustomerDetails();
    });
  
    itemModal.addEventListener('click', function (event) {
      if (event.target.classList.contains('close')) {
        itemModal.style.display = 'none';
      }
    });
  
    previewModal.addEventListener('click', function (event) {
      if (event.target.classList.contains('close')) {
        previewModal.style.display = 'none';
      }
    });
  
    customerModal.addEventListener('click', function (event) {
      if (event.target.classList.contains('close')) {
        customerModal.style.display = 'none';
      }
    });
  
    function fetchParts() {
      fetch('/operational_portal/orders/fetch_parts')
        .then(response => response.json())
        .then(parts => {
          itemsList.innerHTML = parts.map(part => `
            <div class="item">
              <h3>${part.name}</h3>
              <p>${part.description}</p>
              <p>Price: ${part.price}</p>
              <p>Inventory: ${part.inventory || ''}</p>
              <button class="item-details" data-item-id="${part.id}">Details</button>
            </div>
          `).join('');
        });
    }
  
    function fetchProducts() {
      fetch('/operational_portal/orders/fetch_products')
        .then(response => response.json())
        .then(products => {
          itemsList.innerHTML = products.map(product => `
            <div class="item">
              <h3>${product.name}</h3>
              <p>${product.description}</p>
              <p>Price: ${product.price}</p>
              <button class="item-details" data-item-id="${product.id}">Details</button>
            </div>
          `).join('');
        });
    }
  
    function viewCustomerDetails() {
      const customerId = document.querySelector('[name="order[customer_id]"]').value;
      fetch(`/operational_portal/customers/${customerId}`)
        .then(response => response.json())
        .then(customer => {
          customerModal.innerHTML = `
            <div class="modal-content">
              <span class="close">&times;</span>
              <h2>Customer Details</h2>
              <p>Name: ${customer.name}</p>
              <p>Address: ${customer.address}</p>
              <p>Phone: ${customer.phone}</p>
              <p>Street: ${customer.street}</p>
              <p>City: ${customer.city}</p>
              <p>State: ${customer.state}</p>
              <p>Postal Code: ${customer.postal_code}</p>
              <p>Discount: ${customer.discount}</p>
              <button id="edit_customer">Edit</button>
            </div>
          `;
          customerModal.style.display = 'block';
        });
    }
  
    function previewOrder() {
      fetch('/operational_portal/orders/preview')
        .then(response => response.json())
        .then(order => {
          previewModal.innerHTML = `
            <div class="modal-content">
              <span class="close">&times;</span>
              <h2>Order Preview</h2>
              <table>
                <thead>
                  <tr>
                    <th>Name</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Remove</th>
                  </tr>
                </thead>
                <tbody>
                  ${order.items.map(item => `
                    <tr>
                      <td>${item.name}</td>
                      <td><input type="number" value="${item.quantity}" data-item-id="${item.id}" class="item-quantity"></td>
                      <td>${item.price}</td>
                      <td><button class="remove-item" data-item-id="${item.id}">Remove</button></td>
                    </tr>
                  `).join('')}
                </tbody>
              </table>
              <button id="save_order">Save</button>
            </div>
          `;
          previewModal.style.display = 'block';
        });
    }
  
    function viewCustomerDetails() {
      const customerId = document.querySelector('[name="order[customer_id]"]').value;
      fetch(`/operational_portal/customers/${customerId}`)
        .then(response => response.json())
        .then(customer => {
          customerModal.innerHTML = `
            <div class="modal-content">
              <span class="close">&times;</span>
              <h2>Customer Details</h2>
              <p>Name: ${customer.name}</p>
              <p>Address: ${customer.address}</p>
              <p>Phone: ${customer.phone}</p>
              <p>Street: ${customer.street}</p>
              <p>City: ${customer.city}</p>
              <p>State: ${customer.state}</p>
              <p>Postal Code: ${customer.postal_code}</p>
              <p>Discount: ${customer.discount}</p>
              <button id="edit_customer">Edit</button>
            </div>
          `;
          customerModal.style.display = 'block';
        });
    }
  });
  
