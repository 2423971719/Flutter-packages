# DVote example

This plugin provides cryptographic and communication libraries to interact with decentralized votes running on the Vocdoni platform.

* [Getting Started](#getting-started)
* [HD Wallet management](#hd-wallet-management)
* [Signing](#signing)
* [Encryption](#encryption)
* [Entity API](#entity-api)
* [File API](#file-api)
* [Data models](#data-models)

## Getting Started
Import the Dart library on your project and use the static functions available on the `Dvote` class

```dart
import 'package:dvote/dvote.dart';
```

## HD Wallet management
Generating mnemonics and computing private/public keys

```dart
final mnemonic = await generateMnemonic();
final privateKey = await mnemonicToPrivateKey(mnemonic, hdPath: "m/44'/60'/0'/0/5");
final publicKey = await mnemonicToPublicKey(mnemonic);
final address = await mnemonicToAddress(mnemonic);
```

## Signing
Computing signatures using ECDSA cryptography

```dart
final signature = await signString(messageToSign, privateKey);
final valid = await verifySignature(signature, messageToSign, publicKey);
```

## Encryption
Using symmetric AES-GCM encryption to store private data on a mobile device

```dart
final encrypted = await encryptString(myText, myPassphrase);
final decrypted = await decryptString(encrypted, myPassphrase);
```

## Entity API
Use a Vocdoni Gateway to fetch the metadata of an Entity

```dart
import 'package:dvote/dvote.dart';

EntityReference entity = EntityReference();
entity.entityId = "0x1234...";

final entityMeta = await fetchEntity(entity, vocGateway, web3Gateway);

```

## File API
Use a Vocdoni Gateway to fetch static content from the net

```dart
import 'package:dvote/dvote.dart';

final contentUri = ContentURI("ipfs://QmSsfizN4rpSDLRZw3X3WooCPpnBktZ5bEShvmLZuf88iw,https://my-server/file.txt");
final gatewayUri = "ws://hostname:2082/dvote";
final gwPublicKey = "02325f284f50fa52d53579c7873a480b351cc20f7780fa556929f5017283ad2449"

final content = await fetchFileString(contentUri, gatewayUri, gatewayPublicKey: gwPublicKey);
```

## Data models and storage

DVote Flutter exports multiple Dart classes that allow to wrap, parse, serialize and deserialize the most relevant data schemes used within the platform.

```dart
import 'package:dvote/dvote.dart';

// Parse from JSON
Entity entity = parseEntityMetadata("{ ... }");
print(entity.name["en"]);
print(entity.media.avatar);

// Serialize into a binary file
File file1 = File("./my-entity.dat");
file1.writeAsBytes(entity.writeToBuffer());

// Reading back from a file
File file3 = File("./my-entity.dat");
final entityBytes = await file3.readAsBytes();
Entity entity2 = Entity.fromBuffer(entityBytes);
print(entity2.name["en"]);

// Storing a collection of entities
EntitiesStore store = EntitiesStore();
store.entities.addAll([entity, entity2]);
File file2 = File("./entities.dat");
await file2.writeAsBytes(store.writeToBuffer());

```

### Classes

The following classes are exported:

- Entity
  - EntityStore
  - Entity_VotingProcesses
  - Entity_Media
  - Entity_Action_ImageSource
  - Entity_Action
  - Entity_GatewayBootNode
  - Entity_GatewyUpdate
  - Entity_Relay
  - Entity_EntityReference
  - EntitySummary
- Process
  - Process_Census
  - Process_Details
  - Process_Details_Question
  - Process_Details_Question_VoteOption
- Feed
  - FeedsStore
  - FeedPost_Author
  - FeedPost
- Gateway
  - GatewaysStore
- Identity
  - IdentitiesStore
  - Identity_Claim
- Key

### Parsers

Raw JSON data can't be directly serialized into a Protobuf object. For this reason, several parsers are provided:

- `Entity parseEntityMetadata(String json)`
  - `List<Entity_Action> parseEntityActions(List actions)`
  - `List<Entity_GatewayBootNode> parseBootNodes(List bootNodes)`
  - `List<Entity_EntityReference> parseEntityReferences(List entities)`
- `Process parseProcessMetadata(String json)`
  - `List<Process_Details_Question> parseQuestions(List items)`
- `Feed parseFeed(String json)`
