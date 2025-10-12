import KcAdminClient from '@keycloak/keycloak-admin-client';

let adminClient: KcAdminClient | null = null;

export async function getKeycloakAdminClient() {
  if (adminClient) {
    try {
      await adminClient.auth({
        grantType: 'client_credentials',
        clientId: process.env.KEYCLOAK_CLIENT_ID!,
        clientSecret: process.env.KEYCLOAK_CLIENT_SECRET!,
      });
      return adminClient;
    } catch (error) {
      adminClient = null;
    }
  }

  adminClient = new KcAdminClient({
    baseUrl: process.env.KEYCLOAK_URL,
    realmName: process.env.KEYCLOAK_REALM || 'kompose',
  });

  await adminClient.auth({
    grantType: 'client_credentials',
    clientId: process.env.KEYCLOAK_CLIENT_ID!,
    clientSecret: process.env.KEYCLOAK_CLIENT_SECRET!,
  });

  return adminClient;
}

export async function getUsers() {
  const client = await getKeycloakAdminClient();
  return await client.users.find();
}

export async function getUser(id: string) {
  const client = await getKeycloakAdminClient();
  return await client.users.findOne({ id });
}

export async function createUser(user: {
  username: string;
  email: string;
  firstName?: string;
  lastName?: string;
  enabled?: boolean;
  emailVerified?: boolean;
}) {
  const client = await getKeycloakAdminClient();
  return await client.users.create({
    ...user,
    enabled: user.enabled !== false,
    emailVerified: user.emailVerified !== false,
  });
}

export async function updateUser(id: string, user: Partial<{
  username: string;
  email: string;
  firstName: string;
  lastName: string;
  enabled: boolean;
  emailVerified: boolean;
}>) {
  const client = await getKeycloakAdminClient();
  return await client.users.update({ id }, user);
}

export async function deleteUser(id: string) {
  const client = await getKeycloakAdminClient();
  return await client.users.del({ id });
}

export async function resetUserPassword(id: string, password: string, temporary: boolean = false) {
  const client = await getKeycloakAdminClient();
  return await client.users.resetPassword({
    id,
    credential: {
      temporary,
      type: 'password',
      value: password,
    },
  });
}

export async function getClients() {
  const client = await getKeycloakAdminClient();
  return await client.clients.find();
}

export async function getClient(id: string) {
  const client = await getKeycloakAdminClient();
  return await client.clients.findOne({ id });
}

export async function createClient(clientData: any) {
  const client = await getKeycloakAdminClient();
  return await client.clients.create(clientData);
}

export async function updateClient(id: string, clientData: any) {
  const client = await getKeycloakAdminClient();
  return await client.clients.update({ id }, clientData);
}

export async function deleteClient(id: string) {
  const client = await getKeycloakAdminClient();
  return await client.clients.del({ id });
}

export async function getClientSecret(id: string) {
  const client = await getKeycloakAdminClient();
  return await client.clients.getClientSecret({ id });
}

export async function regenerateClientSecret(id: string) {
  const client = await getKeycloakAdminClient();
  return await client.clients.generateNewClientSecret({ id });
}

export async function getGroups() {
  const client = await getKeycloakAdminClient();
  return await client.groups.find();
}

export async function getGroup(id: string) {
  const client = await getKeycloakAdminClient();
  return await client.groups.findOne({ id });
}

export async function createGroup(group: { name: string; path?: string }) {
  const client = await getKeycloakAdminClient();
  return await client.groups.create(group);
}

export async function updateGroup(id: string, group: Partial<{ name: string }>) {
  const client = await getKeycloakAdminClient();
  return await client.groups.update({ id }, group);
}

export async function deleteGroup(id: string) {
  const client = await getKeycloakAdminClient();
  return await client.groups.del({ id });
}

export async function addUserToGroup(userId: string, groupId: string) {
  const client = await getKeycloakAdminClient();
  return await client.users.addToGroup({ id: userId, groupId });
}

export async function removeUserFromGroup(userId: string, groupId: string) {
  const client = await getKeycloakAdminClient();
  return await client.users.delFromGroup({ id: userId, groupId });
}

export async function getUserGroups(userId: string) {
  const client = await getKeycloakAdminClient();
  return await client.users.listGroups({ id: userId });
}

export async function getRealmStats() {
  const client = await getKeycloakAdminClient();
  const [usersData, clients, groups] = await Promise.all([
    client.users.find(),
    client.clients.find(),
    client.groups.count(),
  ]);
  
  // Count active (enabled) users
  const activeUsersCount = usersData.filter(user => user.enabled !== false).length;
  
  return {
    usersCount: usersData.length,
    activeUsersCount,
    clientsCount: clients.length,
    groupsCount: groups.count || 0,
  };
}
