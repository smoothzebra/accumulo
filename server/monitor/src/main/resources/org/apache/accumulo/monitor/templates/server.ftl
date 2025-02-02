<#--

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

-->
      <script>
      /**
       * Creates a DataTable for tablet details.  The "dom" option tells DataTables to only
       * show the table(t), length selector(l) aligned to the left and pagination(p).
       */
      $(document).ready(function() {
        // Global constant for the page
        serv = '${server}';

        // Create a table for tserver list
        tabletResults = $('#perTabletResults').DataTable({
          "ajax": {
            "url": '/rest/tservers/${server}',
            "dataSrc": "currentOperations"
          },
          "stateSave": true,
          "dom": 't<"align-left"l>p',
          "columnDefs": [
              { "targets": "big-num",
                "render": function ( data, type, row ) {
                  if(type === 'display') data = bigNumberForQuantity(data);
                  return data;
                }
              },
              { "targets": "duration",
                "render": function ( data, type, row ) {
                  if(type === 'display') data = timeDuration(data);
                  return data;
                }
              }
            ],
          "columns": [
            { "data": "name",
              "type": "html",
              "render": function ( data, type, row, meta ) {
                if(type === 'display') data = '<a href="/tables/' + row.tableID + '">' + data + '</a>';
                return data;
              }
            },
            { "data": "tablet",
              "type": "html",
              "render": function ( data, type, row, meta ) {
                if(type === 'display') data = '<code>' + data + '</code>';
                return data;
              }
            },
            { "data": "entries" },
            { "data": "ingest" },
            { "data": "query" },
            { "data": "minorAvg" },
            { "data": "minorStdDev" },
            { "data": "minorAvgES" },
            { "data": "majorAvg" },
            { "data": "majorStdDev" },
            { "data": "majorAvgES" }
          ]
        });
        refreshServer();
      });

      </script>
      <div class="row">
        <div class="col-xs-12">
          <h3>${title}</h3>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <table id="tServerDetail" class="table table-bordered table-striped table-condensed">
            <caption><span class="table-caption">${server}</span></caption>
            <thead>
              <tr>
                <th class="firstcell">Hosted&nbsp;Tablets&nbsp;</th>
                <th>Entries&nbsp;</th>
                <th>Minor&nbsp;Compacting&nbsp;</th>
                <th>Major&nbsp;Compacting&nbsp;</th>
                <th>Splitting&nbsp;</th>
              </tr>
            </thead>
            <tbody>
                <tr>
                    <td id="hostedTablets"></td>
                    <td id="entries"></td>
                    <td id="minors"></td>
                    <td id="majors"></td>
                    <td id="splits"></td>
                </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <table id="opHistoryDetails" class="table table-bordered table-striped table-condensed">
            <caption><span class="table-caption">All-Time&nbsp;Tablet&nbsp;Operation&nbsp;Results</span></caption>
            <thead>
              <tr>
                <th class="firstcell">Operation&nbsp;</th>
                <th>Success&nbsp;</th>
                <th>Failure&nbsp;</th>
                <th>Average<br/>Queue&nbsp;Time&nbsp;</th>
                <th>Std.&nbsp;Dev.<br/>Queue&nbsp;Time&nbsp;</th>
                <th>Average<br/>Time&nbsp;</th>
                <th>Std.&nbsp;Dev.<br/>Time&nbsp;</th>
                <th>Percentage&nbsp;Time&nbsp;Spent&nbsp;</th>
              </tr>
            </thead>
            <tbody>
              <tr id="MinorRow"></tr>
              <tr id="MajorRow"></tr>
              <tr id="SplitRow"></tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <table id="currentTabletOps" class="table table-bordered table-striped table-condensed">
            <caption><span class="table-caption">Current&nbsp;Tablet&nbsp;Operation&nbsp;Results</span></caption>
            <thead>
              <tr>
                <th class="firstcell">Minor&nbsp;Average&nbsp;</th>
                <th>Minor&nbsp;Std&nbsp;Dev&nbsp;</th>
                <th>Major&nbsp;Avg&nbsp;</th>
                <th>Major&nbsp;Std&nbsp;Dev&nbsp;</th>
              </tr>
            </thead>
            <tbody>
                <tr>
                  <td id="currentMinorAvg"></td>
                  <td id="currentMinorStdDev"></td>
                  <td id="currentMajorAvg"></td>
                  <td id="currentMajorStdDev"></td>
                </tr>
            </tbody>
          </table>
        </div>
      </div>
      <div class="row">
        <div class="col-xs-12">
          <table id="perTabletResults" class="table table-bordered table-striped table-condensed">
            <caption><span class="table-caption">Detailed Tablet Operations</span></caption>
            <thead>
              <tr>
                <th>Table&nbsp;</th>
                <th title="Run 'getsplits -v' in the Accumulo Shell to associate the encoded tablets with their actual splits.">Tablet&nbsp;<span class="glyphicon glyphicon-info-sign"></span></th>
                <th class="big-num">Entries&nbsp;</th>
                <th class="big-num">Ingest&nbsp;</th>
                <th class="big-num">Query&nbsp;</th>
                <th class="duration">Minor&nbsp;Avg&nbsp;</th>
                <th class="duration">Minor&nbsp;Std&nbsp;Dev&nbsp;</th>
                <th class="big-num">Minor&nbsp;Avg&nbsp;e/s&nbsp;</th>
                <th class="duration">Major&nbsp;Avg&nbsp;</th>
                <th class="duration">Major&nbsp;Std&nbsp;Dev&nbsp;</th>
                <th class="big-num">Major&nbsp;Avg&nbsp;e/s&nbsp;</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>
      </div>
