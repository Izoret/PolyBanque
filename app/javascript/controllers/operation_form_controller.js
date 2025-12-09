import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["totalAmount", "amountShare", "submitButton", "validationMessage"]

    connect() {
        this.checkValidity()
    }

    checkValidity() {
        const total = this.getTotalAmount()
        const sum = this.getSumOfShares()
        const diff = total - sum

        const isTotalValid = total > 0

        const isSumValid = Math.abs(diff) <= 0.011

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

    splitEqually() {
        const total = this.getTotalAmount()
        const sharesCount = this.amountShareTargets.length

        if (sharesCount === 0 || total <= 0) return

        const equalShare = total / sharesCount

        this.amountShareTargets.forEach((input) => {
            input.value = equalShare.toFixed(2)
        })

        this.checkValidity()
    }

    updateParticipations() {
        this.checkValidity()
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