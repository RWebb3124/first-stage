import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter-users"
export default class extends Controller {
  static targets = [ "list", "years", "tags" ]
  connect() {

  }
  filterUsers(event) {
    let query = ""
    // years of experience
    this.yearsValues = []
    const yearsItems=Array.from(this.yearsTarget.children)
    yearsItems.forEach(item => {
      console.log(item.children[0])
      if (item.children[0].checked) {
       // query += `${item.children[0].value}&`
        this.yearsValues.push(item.children[0].value)
      }
    })
    if (this.yearsValues.length > 0) {
      query += `years_experience=${this.yearsValues.join(",")}`
    }
    this.tagsValues = []
    const tagsItems=Array.from(this.tagsTarget.children)
    console.log(tagsItems)
    tagsItems.forEach(item => {
      if (item.children[0].checked) {
        this.tagsValues.push(item.children[0].value)
      }
    })
    if (this.tagsValues.length > 0) {
      if (query.length > 0) {
        query += "&"
      }
      query += `tags=${this.tagsValues.join(",")}`
    }
    console.log(query)
    fetch(`/users?${query}`, {
      headers: {"Accept": "text/plain"
    }
  }).then (response => response.text())
  .then (html => {
    this.listTarget.innerHTML = html
  })
 }
}
