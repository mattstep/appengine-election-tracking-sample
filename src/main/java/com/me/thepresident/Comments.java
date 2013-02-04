package com.me.thepresident;
import java.util.*;
import com.google.appengine.api.datastore.*;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

public class Comments {
  static public void store(String text, String user) {
    Entity commentEntity = new Entity("Comment");
    commentEntity.setProperty("user", user);
    commentEntity.setProperty("date", new Date());
    commentEntity.setProperty("text", text);

    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    datastore.put(commentEntity);
    MemcacheServiceFactory.getMemcacheService().delete("100Comments"); //kill cache
  }

  public static List<Entity> retrieveAllCached()
  {
    MemcacheService cache = MemcacheServiceFactory.getMemcacheService();
    List<Entity> comments = (List<Entity>)cache.get("100Comments");
    if (comments == null)
    {
      comments = retrieveAll(); // read from datastore
      if (comments != null)
        cache.put("100Comments", comments); // store in memcache
    }
    return comments;
  }

  static public List<Entity> retrieveAll() {
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

    Query query = new Query("Comment");
    query.addSort("date", Query.SortDirection.DESCENDING);
    return datastore.prepare(query).asList(FetchOptions.Builder.withLimit(100));
  }
}
