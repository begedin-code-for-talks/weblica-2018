import 'phoenix_html';
import socket from './socket';

const token = document.createElement('span');
token.classList.add('token');

const render = (name, { tokens }) => {
  console.log('rendering', tokens);
  const container = document.querySelector(`#${name} .tokens`);
  container.innerHTML = '';
  tokens.forEach(() => container.appendChild(token.cloneNode()));
}

const setupChannel = (name) => {
  const channel = socket.channel(`${name}:lobby`, {});

  channel.join()
    .receive('ok', resp => { console.log(`Joined ${name}`, resp) })
    .receive('error', resp => { console.log(`Unable to join ${name}`, resp) });

  return channel;
}

const [basic, supervisor, genServer] =
  ['basic', 'supervisor', 'genServer'].map((channelName) => {
    const channel = setupChannel(channelName);

    const addButton = document.querySelector(`#${channelName} .btn-primary`);
    const removeButton = document.querySelector(`#${channelName} .btn-success`);
    const crashButton = document.querySelector(`#${channelName} .btn-danger`);

    addButton.onclick = () => channel.push('add');
    removeButton.onclick = () => channel.push('remove');
    crashButton.onclick = () => channel.push('crash');

    channel.on('status', payload => render(channelName, payload));

    return channel;
  });
