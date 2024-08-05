// app/javascript/controllers/order_status_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status", "save"]
  static values = {
    originalStatus: String,
    orderId: Number
  }

  connect() {
    this.hasChanges = false
    this.intendedUrl = null
    this.originalStatusValue = this.statusTarget.value
  }

  statusChanged() {
    this.hasChanges = this.statusTarget.value !== this.originalStatusValue
    this.saveTarget.style.display = this.hasChanges ? 'block' : 'none'
  }

  save() {
    fetch(`/operational_portal/orders/${this.orderIdValue}`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ order: { status: this.statusTarget.value } })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        this.originalStatusValue = this.statusTarget.value
        this.hasChanges = false
        this.saveTarget.style.display = 'none'
        alert('Order status updated successfully')
      } else {
        alert('Failed to update order status')
      }
    })
    .catch(error => {
      console.error('Error:', error)
      alert('An error occurred while updating the order status')
    })
  }

  beforeNavigate(event) {
    if (this.hasChanges) {
      event.preventDefault()
      this.intendedUrl = event.detail.url
      this.showWarningModal()
    }
  }

  showWarningModal() {
    const modal = document.getElementById('navigation-warning-modal')
    modal.style.display = 'block'
  }

  saveAndNavigate() {
    this.save()
    this.navigate()
  }

  discardAndNavigate() {
    this.hasChanges = false
    this.navigate()
  }

  cancelNavigation() {
    const modal = document.getElementById('navigation-warning-modal')
    modal.style.display = 'none'
  }

  navigate() {
    const modal = document.getElementById('navigation-warning-modal')
    modal.style.display = 'none'
    if (this.intendedUrl) {
      Turbo.visit(this.intendedUrl)
    }
  }
}