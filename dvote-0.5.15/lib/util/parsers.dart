import "dart:convert";
import 'package:flutter/rendering.dart';

import "package:dvote/models/dart/entity.pb.dart";
import "package:dvote/models/dart/feed.pb.dart";
import 'package:dvote/models/dart/process.pb.dart';

// ////////////////////////////////////////////////////////////////////////////
// ENTITY
// ////////////////////////////////////////////////////////////////////////////

EntityMetadata parseEntityMetadata(String json) {
  try {
    final mapEntity = jsonDecode(json);
    if (!(mapEntity is Map)) throw "The entity metadata is invalid";

    final EntityMetadata entity = EntityMetadata();
    entity.version = mapEntity["version"] ?? "";
    if (mapEntity["languages"] != null)
      entity.languages.addAll(mapEntity["languages"]?.cast<String>() ?? []);
    if (mapEntity["name"] != null)
      entity.name.addAll(mapEntity["name"]?.cast<String, String>() ?? {});
    if (mapEntity["description"] != null)
      entity.description
          .addAll(mapEntity["description"]?.cast<String, String>() ?? {});

    if (mapEntity["votingProcesses"] != null) {
      EntityMetadata_VotingProcesses votingProcesses =
          EntityMetadata_VotingProcesses();
      if (mapEntity["votingProcesses"]["active"] != null)
        votingProcesses.active.addAll(
            mapEntity["votingProcesses"]["active"]?.cast<String>() ?? []);
      if (mapEntity["votingProcesses"]["ended"] != null)
        votingProcesses.ended.addAll(
            mapEntity["votingProcesses"]["ended"]?.cast<String>() ?? []);
      entity.votingProcesses = votingProcesses;
    }

    if (mapEntity["newsFeed"] != null)
      entity.newsFeed
          .addAll(mapEntity["newsFeed"]?.cast<String, String>() ?? {});

    if (mapEntity["media"] != null) {
      EntityMetadata_Media media = EntityMetadata_Media();
      if (mapEntity["media"]["avatar"] != null)
        media.avatar = mapEntity["media"]["avatar"] ?? "";
      if (mapEntity["media"]["header"] != null)
        media.header = mapEntity["media"]["header"] ?? "";
      entity.media = media;
    }

    final actions = parseEntityActions(mapEntity["actions"]);
    entity.actions.addAll(actions);

    final bootEntities = parseEntityReferences(mapEntity["bootEntities"]);
    entity.bootEntities.addAll(bootEntities);

    final fallbackBootNodeEntities =
        parseEntityReferences(mapEntity["fallbackBootNodeEntities"]);
    entity.fallbackBootNodeEntities.addAll(fallbackBootNodeEntities);

    final trustedEntities = parseEntityReferences(mapEntity["trustedEntities"]);
    entity.trustedEntities.addAll(trustedEntities);

    final censusServiceManagedEntities =
        parseEntityReferences(mapEntity["censusServiceManagedEntities"]);
    entity.censusServiceManagedEntities.addAll(censusServiceManagedEntities);

    return entity;
  } catch (err) {
    throw FlutterError("The entity metadata could not be parsed");
  }
}

List<EntityMetadata_Action> parseEntityActions(List actions) {
  if (!(actions is List)) return [];
  return actions.whereType<Map>().map((action) {
    EntityMetadata_Action result = EntityMetadata_Action();
    try {
      // IMPORTANT: Assume that values may be empty

      result.type = action["type"] ?? "";
      result.name.addAll(action["name"]?.cast<String, String>() ?? {});
      result.visible = action["visible"] ?? "true";
      // type = browser / image
      if (action["url"] is String) result.url = action["url"];
      // type = browser
      if (action["register"] is bool) result.register = action["register"];
      // type = image
      if (action["imageSources"] is List) {
        final sources = action["imageSources"].whereType<Map>().map((source) {
          EntityMetadata_Action_ImageSource result =
              EntityMetadata_Action_ImageSource();
          result.type = source["type"] ?? "";
          result.name = source["name"] ?? "";
          result.orientation = source["orientation"] ?? "";
          result.overlay = source["overlay"] ?? "";
          result.caption
              .addAll(source["caption"]?.cast<String, String>() ?? {});
          return result;
        });
        result.imageSources.addAll(sources);
      }
    } catch (err) {
      print(err);
    }
    return result;
  }).toList();
}

List<EntityReference> parseEntityReferences(List entities) {
  if (!(entities is List)) return [];
  return entities.whereType<Map>().map((entity) {
    EntityReference result = EntityReference();
    result.entityId = entity["entityId"] ?? "";
    result.entryPoints.addAll(entity["entryPoints"]?.cast<String>() ?? []);
    return result;
  }).toList();
}

// ////////////////////////////////////////////////////////////////////////////
// VOTING PROCESS
// ////////////////////////////////////////////////////////////////////////////

ProcessMetadata parseProcessMetadata(String json) {
  try {
    ProcessMetadata result = ProcessMetadata();
    final mapProcess = jsonDecode(json);
    if (!(mapProcess is Map)) return null;

    result.version = mapProcess["version"] ?? "";
    result.type = mapProcess["type"] ?? "";
    result.startBlock = mapProcess["startBlock"] ?? 0;
    result.numberOfBlocks = mapProcess["numberOfBlocks"] ?? 0;

    ProcessMetadata_Census census = ProcessMetadata_Census();
    if (mapProcess["census"] != null) {
      census.merkleRoot = mapProcess["census"]["merkleRoot"] ?? "";
      census.merkleTree = mapProcess["census"]["merkleTree"] ?? "";
    }
    result.census = census;

    ProcessMetadata_Details details = ProcessMetadata_Details();
    if (mapProcess["details"] is Map) {
      details.entityId = mapProcess["details"]["entityId"];
      details.encryptionPublicKey =
          mapProcess["details"]["encryptionPublicKey"];
      details.title
          .addAll(mapProcess["details"]["title"]?.cast<String, String>() ?? {});
      details.description.addAll(
          mapProcess["details"]["description"]?.cast<String, String>() ?? {});
      details.headerImage = mapProcess["details"]["headerImage"];

      if (mapProcess["details"]["questions"] is List) {
        final questions = parseQuestions(mapProcess["details"]["questions"]);

        details.questions.addAll(questions);
      }
    }
    result.details = details;

    return result;
  } catch (err) {
    throw FlutterError("The process metadata could not be parsed");
  }
}

List<ProcessMetadata_Details_Question> parseQuestions(List items) {
  return items.whereType<Map>().map((item) {
    final ProcessMetadata_Details_Question result =
        ProcessMetadata_Details_Question();
    if (item["type"] is String) result.type = item["type"];
    if (item["question"] is Map)
      result.question.addAll(item["question"]?.cast<String, String>() ?? {});
    if (item["description"] is Map)
      result.description
          .addAll(item["description"]?.cast<String, String>() ?? {});

    final voteOptions =
        (item["voteOptions"] as List).whereType<Map>().map((item) {
      final result = ProcessMetadata_Details_Question_VoteOption();
      if (item["title"] is Map)
        result.title.addAll(item["title"]?.cast<String, String>() ?? {});
      if (item["value"] is String) result.value = item["value"];

      return result;
    }).toList();
    result.voteOptions.addAll(voteOptions);

    return result;
  }).toList();
}

// ////////////////////////////////////////////////////////////////////////////
// FEED
// ////////////////////////////////////////////////////////////////////////////

Feed parseFeed(String json) {
  try {
    Feed result = Feed();
    final mapFeed = jsonDecode(json);
    if (!(mapFeed is Map)) return null;

    if (mapFeed["version"] != null) result.version = mapFeed["version"];
    if (mapFeed["title"] != null) result.title = mapFeed["title"];
    if (mapFeed["home_page_url"] != null)
      result.homePageUrl = mapFeed["home_page_url"];
    if (mapFeed["description"] != null)
      result.description = mapFeed["description"];
    if (mapFeed["feed_url"] != null) result.feedUrl = mapFeed["feed_url"];
    if (mapFeed["icon"] != null) result.icon = mapFeed["icon"];
    if (mapFeed["favicon"] != null) result.favicon = mapFeed["favicon"];
    result.expired = mapFeed["expired"] ?? false;

    if (mapFeed["items"] is List) {
      List<FeedPost> items =
          (mapFeed["items"] as List).whereType<Map>().map((item) {
        FeedPost post = FeedPost();
        if (item["id"] != null) post.id = item["id"];
        if (item["title"] != null) post.title = item["title"];
        if (item["summary"] != null) post.summary = item["summary"];
        if (item["content_text"] != null)
          post.contentText = item["content_text"];
        if (item["content_html"] != null)
          post.contentHtml = item["content_html"];
        if (item["url"] != null) post.url = item["url"];
        if (item["image"] != null) post.image = item["image"];
        if (item["tags"] != null)
          post.tags.addAll((item["tags"] as List).cast<String>());
        if (item["date_published"] != null)
          post.datePublished = item["date_published"];
        if (item["date_modified"] != null)
          post.dateModified = item["date_modified"];

        FeedPost_Author author = FeedPost_Author();
        if (item["author"] != null) {
          if (item["author"]["name"] != null)
            author.name = item["author"]["name"];
          if (item["author"]["url"] != null) author.url = item["author"]["url"];
          post.author = author;
        }
        return post;
      }).toList();
      result.items.addAll(items);
    }

    return result;
  } catch (err) {
    throw FlutterError("The news feed could not be parsed");
  }
}
