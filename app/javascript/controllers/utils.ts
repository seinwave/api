function addToggleListener(selected_id, toggled_element_id, toggle_class) {
  let selected_element = document.querySelector(`#${selected_id}`);
  selected_element &&
    selected_element.addEventListener('click', function (event) {
      event.preventDefault();
      let toggled_element = document.querySelector(`#${toggled_element_id}`);
      toggled_element && toggled_element.classList.toggle(toggle_class);
    });
}
