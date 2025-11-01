import { REST, Routes } from 'discord.js';
import { TOKEN, CLIENT_ID } from './env.js';

const commands = [
  {
    name: 'ping',
    description: 'Replies with Pong!',
  },
];

if (!TOKEN) {
  throw new Error('TOKEN is not defined');
}

const rest = new REST({ version: '10' }).setToken(TOKEN);

try {
  console.log('Started refreshing application (/) commands.');

  await rest.put(Routes.applicationCommands(CLIENT_ID), { body: commands });

  console.log('Successfully reloaded application (/) commands.');
} catch (error) {
  console.error(error);
}
