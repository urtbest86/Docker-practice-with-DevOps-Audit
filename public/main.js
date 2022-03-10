// main.js
const update = document.querySelector('#update-button');
const deleteButton = document.querySelector('#delete-button');
const messageDiv = document.querySelector('#message');

update.addeventListener('click', function(event) {
  // Send PUT Request here
  fetch('/quotes', {
  	method: 'put',
    // server에 우리가 보내는 JSON data의 Content-Type을 설정해줘야 한다.
    headers: { 'Content-Type' : 'application/json' },
    // JSON으로 보낸 데이터를 변환해야 한다
    body: JSON.stringify({
    	name: '현덕맨',
      quote: '살려줘~'
    })
  })
  .then(res => {
    if (res.ok) return res.json();
  })
  .then(response => {
    console.log(response);
    window.location.reload(true);
  });
});

deleteButton.addeventListener('click', function(event) {
  fetch('/quotes', {
    method: 'delete',
    headers: { 'Content-Type' : 'application/json' },
    body: JSON.stringify({
      name: '현덕맨'
    })
  })
    .then(res => {
      if(res.ok)  return res.json();
    })
    .then(data => {
      if(data === 'No quote to delete') {
        messageDiv.textContent = 'No BabO quote to delete'
      } else {
        window.location.reload();
      }
    });
});
