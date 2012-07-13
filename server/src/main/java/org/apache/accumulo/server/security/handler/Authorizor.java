/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.accumulo.server.security.handler;

import org.apache.accumulo.core.client.AccumuloSecurityException;
import org.apache.accumulo.core.security.Authorizations;

/**
 * This interface is used for the system which will be used for getting a users Authorizations. If the implementation does not support configuration through
 * Accumulo, it should throw an AccumuloSecurityException with the error code UNSUPPORTED_OPERATION
 */
public interface Authorizor {
  /**
   * Sets up the authorizor for a new instance of Accumulo
   * 
   * @param instanceId
   */
  public void initialize(String instanceId);

  /**
   * Used to validate that the Authorizor, Authenticator, and permission handler can coexist
   * 
   * @param auth
   * @return
   */
  public boolean validSecurityHandlers(Authenticator auth, PermissionHandler pm);
  
  /**
   * Used to initialize security for the root user
   * 
   * @param rootuser
   * @throws AccumuloSecurityException
   */
  public void initializeSecurity(String rootuser) throws AccumuloSecurityException;
  
  /**
   * Used to change the authorizations for the user
   * 
   * @param user
   * @param authorizations
   * @throws AccumuloSecurityException
   */
  public void changeAuthorizations(String user, Authorizations authorizations) throws AccumuloSecurityException;
  
  /**
   * Used to get the authorizations for the user
   * 
   * @param user
   * @return
   * @throws AccumuloSecurityException
   */
  public Authorizations getCachedUserAuthorizations(String user) throws AccumuloSecurityException;
  
  /**
   * Initializes a new user
   * 
   * @param user
   * @throws AccumuloSecurityException
   */
  public void initUser(String user) throws AccumuloSecurityException;
  
  /**
   * Deletes a user
   * 
   * @param user
   * @throws AccumuloSecurityException
   */
  public void dropUser(String user) throws AccumuloSecurityException;
}
