package com.me.thepresident;

import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CronServlet extends HttpServlet {
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException
  {
    Entity Elected = new Entity("Elected");
    Elected.setProperty("name", "Barack obama"); //or Mitt Romney
    Elected.setProperty("image", "obama.png"); //or romney.png
    DatastoreServiceFactory.getDatastoreService().put(Elected);
  }
}
