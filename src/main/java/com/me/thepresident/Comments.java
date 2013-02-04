package com.me.thepresident;
import java.util.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.datastore.Entity;

public class Comments {
  static public void store(String text, String user) {
    Entity commentEntity = new Entity("Comment");
    commentEntity.setProperty("user", user);
    commentEntity.setProperty("date", new Date());
    commentEntity.setProperty("text", text);

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    datastore.put(commentEntity);
  }

  static public List<Entity> retrieveAll() {
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

    Query query = new Query("Comment");
    query.addSort("date", Query.SortDirection.DESCENDING);
    return datastore.prepare(query).asList(FetchOptions.Builder.withLimit(100));
  }
}
