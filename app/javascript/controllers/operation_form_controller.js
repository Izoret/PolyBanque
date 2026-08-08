import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["name", "totalAmount", "amountShare", "submitButton", "participationToggle", "participationWrapper"]

    connect() {
        this.updateWrapperStates()
        this.checkValidity()
    }

    updateWrapperStates() {
        this.participationToggleTargets.forEach(checkbox => {
            const wrapper = checkbox.closest('.participation-wrapper')
            if (checkbox.checked) {
                wrapper.classList.add('active')
            } else {
                wrapper.classList.remove('active')
            }
        })
    }

    splitEqually() {
        const total = this.getTotalAmount()
        // On ne divise qu'entre ceux qui sont cochés
        const participatingToggles = this.participationToggleTargets.filter(t => t.checked)
        const sharesCount = participatingToggles.length

        if (sharesCount === 0) return

        const equalShare = total / sharesCount

        this.amountShareTargets.forEach((input) => {
            const wrapper = input.closest('.participation-wrapper')
            const checkbox = wrapper.querySelector('input[type="checkbox"]')

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

        // Si on décoche, on met à 0
        if (!checkbox.checked) {
            input.value = "0.00"
        }

        this.updateWrapperStates()
        this.checkValidity()
    }

    onAmountInput(event) {
        const input = event.target
        const value = parseFloat(input.value)
        const wrapper = input.closest('.participation-wrapper')
        const checkbox = wrapper.querySelector('input[type="checkbox"]')

        // Si on tape un montant positif, on coche automatiquement la case
        if (!isNaN(value) && value > 0) {
            checkbox.checked = true
        } else if (value === 0) {
            checkbox.checked = false
        }

        this.updateWrapperStates()
        this.checkValidity()
    }

    updateParticipations() {
        this.checkValidity()
    }

    checkValidity() {
        const name = this.hasNameTarget ? this.nameTarget.value.trim() : ""
        const total = this.getTotalAmount()
        const sum = this.getSumOfShares()
        const diff = total - sum

        const isNameValid = name.length > 0
        const isTotalValid = total > 0
        const isSumValid = Math.abs(diff) <= 0.011

        const isValid = isNameValid && isTotalValid && isSumValid

        if (this.hasSubmitButtonTarget) {
            const button = this.submitButtonTarget

            if (isValid) {
                button.disabled = false
                button.value = "Sauvegarder"
                button.classList.remove("btn-error")
                return
            }

            button.disabled = true
            button.classList.add("btn-error")

            if (!isNameValid) {
                button.value = "Faut rentrer un nom !"
            } else if (!isTotalValid) {
                button.value = "Faut un montant positif !"
            } else {
                button.value = `La somme des parts (${sum.toFixed(2)}) ≠ Total (${total.toFixed(2)}). Écart: ${Math.abs(diff).toFixed(2)} €`
            }
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