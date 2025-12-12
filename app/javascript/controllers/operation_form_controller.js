import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["totalAmount", "amountShare", "submitButton", "validationMessage", "participationToggle"]

    connect() {
        this.checkValidity()
    }

    splitEqually() {
        const total = this.getTotalAmount()

        const participatingToggles = this.participationToggleTargets.filter(t => t.checked)
        const sharesCount = participatingToggles.length

        if (sharesCount === 0 || total <= 0) return

        const equalShare = total / sharesCount

        this.amountShareTargets.forEach((input) => {
            const wrapper = input.closest('.participation-wrapper')
            const checkbox = wrapper.querySelector('[data-operation-form-target="participationToggle"]')

            if (checkbox.checked) {
                input.value = equalShare.toFixed(2)
            } else {
                input.value = "0.00"
            }
        })

        this.checkValidity()
    }

    toggleParticipation(event) {
        const checkbox = event.target
        const wrapper = checkbox.closest('.participation-wrapper')
        const input = wrapper.querySelector('[data-operation-form-target="amountShare"]')

        if (!checkbox.checked) input.value = "0.00"

        this.checkValidity()
    }

    onAmountInput(event) {
        const input = event.target
        const value = parseFloat(input.value)

        if (!isNaN(value) && value > 0) {
            const wrapper = input.closest('.participation-wrapper')
            const checkbox = wrapper.querySelector('[data-operation-form-target="participationToggle"]')
            checkbox.checked = true
        }

        this.checkValidity()
    }

    updateParticipations() {
        this.checkValidity()
    }

    checkValidity() {
        const total = this.getTotalAmount()
        const sum = this.getSumOfShares()
        const diff = total - sum

        const isTotalValid = total > 0

        const isSumValid = Math.abs(diff) <= 0.1

        const isValid = isTotalValid && isSumValid
        this.submitButtonTarget.disabled = !isValid

        this.validationMessageTarget.innerHTML = ""
        if (!isTotalValid) {
            this.validationMessageTarget.innerHTML = "Le montant total doit être supérieur à 0."
        } else if (!isSumValid) {
            const formattedDiff = Math.abs(diff).toFixed(2)
            this.validationMessageTarget.innerHTML = `La somme des participations (${sum.toFixed(2)}) ne correspond pas au total (${total.toFixed(2)}). Écart: ${formattedDiff}.`
        }
    }

    getTotalAmount() {
        const total = parseFloat(this.totalAmountTarget.value)
        return isNaN(total) ? 0 : total
    }

    getSumOfShares() {
        let sum = 0
        this.amountShareTargets.forEach((input) => {
            const share = parseFloat(input.value)
            if (!isNaN(share)) {
                sum += share
            }
        })
        return sum
    }
}