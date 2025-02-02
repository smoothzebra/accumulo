/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
"use strict";

/**
 * Creates manager initial table
 */
$(document).ready(function() {
  refreshManager();
});

/**
 * Makes the REST calls, generates the tables with the new information
 */
function refreshManager() {
  getManager().then(function() {
    refreshManagerTable();
  });
  getRecoveryList().then(function() {
    recoveryList();
  });
}


/*
 * The tables refresh function will do this functionality
 * If tables are removed from Manager, uncomment this function
 */
/**
 * Used to redraw the page
 */
/*function refresh() {
  refreshManager();
}*/

/**
 * Creates recovery list table
 */
function recoveryList() {
  /*
   * Get the recovery value obtained earlier,
   * if it doesn't exists, create an empty array
   */
  var data = sessionStorage.recoveryList === undefined ?
      [] : JSON.parse(sessionStorage.recoveryList);

  clearTableBody('recoveryList');

  // If there is no recovery list data, hide the table
  if (data.length === 0 || data.recoveryList.length === 0) {
    $('#recoveryList').hide();
  } else {
    $('#recoveryList').show();

    // Creates the table for the recovery list
    $.each(data.recoveryList, function(key, val) {
      var items = [];
      items.push(createFirstCell(val.server, val.server));
      items.push(createRightCell(val.log, val.log));
      var duration = timeDuration(parseInt(val.time));
      items.push(createRightCell(val.time, duration));
      var percentProgress = (val.progress * 100).toFixed(2) + '%';
      items.push(createRightCell(val.progress, percentProgress));

      $('<tr/>', {
        html: items.join('')
      }).appendTo('#recoveryList tbody');
    });
  }
}

/**
 * Generates the manager table
 */
function refreshManagerTable() {
  // Gets the manager status
  var status = JSON.parse(sessionStorage.status).managerStatus;

  // Hide the banner and the manager table
  $('#managerBanner').hide();
  clearTableBody('managerStatus');
  $('#managerStatus').hide();

  // If manager status is error, show banner, otherwise, create manager table
  if (status === 'ERROR') {
    $('#managerBanner').show();
  } else {
    $('#managerStatus').show();
    var data = JSON.parse(sessionStorage.manager);
    var items = [];
    items.push(createFirstCell(data.manager, data.manager));

    items.push(createRightCell(data.onlineTabletServers,
        data.onlineTabletServers));

    items.push(createRightCell(data.totalTabletServers,
        data.totalTabletServers));
    var date = data.lastGC;
    //this will be a finish time or a status of Running, Waiting, or down
    if (!isNaN(date))
        date = new Date(parseInt(data.lastGC)).toLocaleString().split(' ').join('&nbsp;');

    items.push(createLeftCell(data.lastGC, '<a href="/gc">' + date + '</a>'));

    items.push(createRightCell(data.tablets,
        bigNumberForQuantity(data.tablets)));

    items.push(createRightCell(data.unassignedTablets,
        bigNumberForQuantity(data.unassignedTablets)));

    items.push(createRightCell(data.numentries,
        bigNumberForQuantity(data.numentries)));

    items.push(createRightCell(data.ingestrate,
        bigNumberForQuantity(Math.round(data.ingestrate))));

    items.push(createRightCell(data.entriesRead,
        bigNumberForQuantity(Math.round(data.entriesRead))));

    items.push(createRightCell(data.queryrate,
        bigNumberForQuantity(Math.round(data.queryrate))));

    items.push(createRightCell(data.holdTime, timeDuration(data.holdTime)));

    items.push(createRightCell(data.osload, bigNumberForQuantity(data.osload)));

    $('<tr/>', {
     html: items.join('')
    }).appendTo('#managerStatus tbody');
  }
}
