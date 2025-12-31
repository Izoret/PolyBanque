import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["totalAmount", "amountShare", "submitButton", "validationMessage", "participationToggle", "participationWrapper"]

    connect() {
        this.updateWrapperStates()
        this.checkValidity()
    }

    // Met à jour visuellement les cartes (ajoute la classe .active)
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

    selectAll() {
        this.participationToggleTargets.forEach((checkbox) => {
            checkbox.checked = true
        })
        this.updateWrapperStates()
        this.checkValidity()
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
            const checkbox = wrapper.querySelector('input[type="checkbox"]') // Le toggle

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
             // Optionnel : décocher si 0 ? Gardons coché pour l'instant pour éviter les erreurs ux
        }

        this.updateWrapperStates()
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
        const isSumValid = Math.abs(diff) <= 0.011

        const isValid = isTotalValid && isSumValid

        if (this.hasSubmitButtonTarget) {
            this.submitButtonTarget.disabled = !isValid
        }

        if (this.hasValidationMessageTarget) {
            this.validationMessageTarget.innerHTML = ""
            if (!isTotalValid) {
                this.validationMessageTarget.innerHTML = "Le montant total doit être supérieur à 0."
            } else if (!isSumValid) {
                const formattedDiff = Math.abs(diff).toFixed(2)
                this.validationMessageTarget.innerHTML = `La somme des parts (${sum.toFixed(2)}) ≠ Total (${total.toFixed(2)}). Écart: ${formattedDiff} €`
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