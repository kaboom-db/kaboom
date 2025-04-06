import { Controller } from '@hotwired/stimulus'
import { DraggableContainer, DragStartEvent, MirrorCreateEvent, Sortable, SortableStopEvent } from '@shopify/draggable'
import { sendRequest } from '../common/request'

// Connects to data-controller="draggable"
export default class extends Controller {
  static values = { readonly: Boolean }

  declare readonlyValue: boolean

  declare sortable: Sortable
  requestInFlight = false

  connect () {
    if (this.readonlyValue) return
    this.sortable = new Sortable(this.element as DraggableContainer, {
      draggable: '.draggable'
    })
    this.sortable.on('drag:start', this.onDragStart.bind(this))
    this.sortable.on('sortable:stop', this.onSorted.bind(this))
    this.sortable.on('mirror:create', this.onMirrorCreate.bind(this))
  }

  onDragStart (event: DragStartEvent): void {
    const target = event.originalEvent.target as HTMLElement
    if (target !== null && Array.from(target.classList).includes('prevent-drag')) {
      event.cancel()
    }
  }

  onMirrorCreate (event: MirrorCreateEvent): void {
    event.source.style.width = `${this.element.clientWidth}px`
    event.source.style.minWidth = '0'
  }

  onSorted (event: SortableStopEvent): void {
    if (event.oldIndex === event.newIndex) return

    if (this.requestInFlight) {
      this.revert(event.oldContainer)
      return
    }

    const url = event.dragEvent.source.dataset.movePositionUrl ?? ''
    const position = event.newIndex + 1
    this.requestInFlight = true
    sendRequest(url, { position })
      .then(() => { this.requestInFlight = false })
      .catch(() => { this.revert(event.oldContainer) })
  }

  revert (oldContainer: HTMLElement): void {
    this.requestInFlight = false
    this.element.outerHTML = oldContainer.outerHTML
  }
}
