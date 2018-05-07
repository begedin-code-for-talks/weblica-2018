import 'phoenix_html';
import socket from './socket';

const [basic, agent, supervisor, genServer] =
  ['basic', 'agent', 'supervisor', 'genServer'].map((channelName) => {
    let channel = socket.channel(`${channelName}:lobby`, {})

    channel.join()
      .receive('ok', resp => {
        console.log(`${channelName} joined successfully`, resp);
        buildList(channelName, resp);
      })
      .receive('error', resp => { console.log(`Unable to join ${channelName}`, resp) });

    return channel;
  });

const channels = { basic, agent, supervisor, genServer };

let urlField = document.getElementById('url');
let submitUrlButton = document.getElementById('submit');

submit.onclick = function() {
  let channelName = document.querySelector('[name=channel]:checked').value;
  channels[channelName].push('shorten', { body: urlField.value });
}

const items = {
  basic: document.getElementById('basicItems'),
  genServer: document.getElementById('genServerItems'),
  agent: document.getElementById('agentItems'),
  supervisor: document.getElementById('supervisorItems')
};

const buildList = (name, payload) => {
  items[name].innerHTML = '';

  Object.entries(payload).forEach(([long, short]) => {
    const item = buildListItem(long, short);
    items[name].appendChild(item);
  });
}

const buildListItem = (long, short) => {
  const anchor = document.createElement('a');
  anchor.href = short;
  anchor.innerText = `${short} - ${long}`;
  const item = document.createElement('li');
  item.appendChild(anchor);
  item.classList.add('list-group-item');

  return item;
};

Object.entries(channels).forEach(([name, channel]) => {
  channel.on('state', payload => {
    console.log(`${name}: state, ${JSON.stringify(payload)}`);
    buildList(name, payload);
  });
})
