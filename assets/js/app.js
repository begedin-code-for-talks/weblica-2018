import 'phoenix_html';
import socket from './socket';

const pellet = document.createElement('span');
pellet.classList.add('pellet');

const renderFood = (name, { stomach }) => {
  const container = document.querySelector(`#${name} .food`);
  container.innerHTML = '';
  stomach.forEach(() => container.appendChild(pellet.cloneNode()));
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

    const feedButton = document.querySelector(`#${channelName} .btn-success`);
    const eatButton = document.querySelector(`#${channelName} .btn-primary`);
    const punchButton = document.querySelector(`#${channelName} .btn-danger`);

    feedButton.onclick = () => channel.push('feed');
    eatButton.onclick = () => channel.push('eat');
    punchButton.onclick = () => channel.push('punch');

    channel.on('stomach', payload => renderFood(channelName, payload));

    return channel;
  });
