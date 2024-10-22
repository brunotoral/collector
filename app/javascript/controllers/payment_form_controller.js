import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="payment-form"
export default class extends Controller {
  static targets = ["creditCardForm", "paymentMethod"]

  connect() {
    this.paymentMethodTarget.addEventListener("change", () => {
      this.updateCreditCardFields(this.paymentMethodTarget.value);
    });
  }
  updateCreditCardFields(value) {
    this.creditCardFormTarget.style.display = value === "credit_card" ? "" : "none"
    const inputs = this.creditCardFormTarget.querySelectorAll('input');

    inputs.forEach(input => {
      input.required = value === "credit_card";
    });
  }
}
