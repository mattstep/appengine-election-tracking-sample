package com.me.thepresident;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

import java.util.Random;

public class Counter {

  public static void increment(String name) {
    MemcacheService cache = MemcacheServiceFactory.getMemcacheService();
    Long val = cache.increment(name, 1);
    if (val == null) {
      val = Counter.read(name);
      if (val == null)
        val = cache.increment(name, 1, 0L); //0=init val
      else
        val++;
    }
    Counter.write(name, val);
  }

  static Long read(String name)
  {
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

    Query query = new Query("Counter")
        .addFilter("name", Query.FilterOperator.EQUAL, name)
        .addSort("value", Query.SortDirection.DESCENDING);

    Iterable<Entity> entities = datastore.prepare(query).asIterable();

    if(!entities.iterator().hasNext()) {
      return null;
    }

    Entity e = entities.iterator().next();

    return e == null ? null : (Long) e.getProperty("value");
  }

  static void write(String name, Long value)
  {
    Random r = new Random();
    Integer shardN = r.nextInt(10);

    Key key = KeyFactory.createKey("Counter", name + "_shard" + shardN.toString());
    Entity counter = new Entity(key);
    counter.setProperty("name", name);
    counter.setProperty("value", value);

    DatastoreServiceFactory.getDatastoreService().put(counter);
  }
}
