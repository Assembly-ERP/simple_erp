/*import consumer from "./consumer"

consumer.subscriptions.create("CustomerChannel", {
  received(data) {
    // This is called when new data is broadcasted from the server
    // Update the customer search list with the new customer data
    const customerList = document.getElementById('customer-list');
    if (customerList) {
      const newCustomer = document.createElement('li');
      newCustomer.textContent = data.name; // Assuming data contains customer name
      newCustomer.setAttribute('data-id', data.id); // Assuming data contains customer id
      newCustomer.classList.add('customer-item');
      customerList.appendChild(newCustomer);
    }
  }
}); */
