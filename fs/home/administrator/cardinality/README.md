## Reference

[cardinality aggregation](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-aggregations-metrics-cardinality-aggregation.html)

## Seed

* Create a project with name "2617"
* Import opal archive 2617.zip into this project

## Query 1

Run:

```
opal rest -o http://localhost:8080 -u administrator -p password -m POST /datasource/2617/table/samples_donors/facets/_search --content-type application/json -j < query1/opal-request.json
```

Query criteria: 

```
SampleStatus="Lesional material" and ConsentStatus="Informed consent"
```

Result: 

```
3 Samples, 2 Donors
```

## Query 2

Run:

```
opal rest -o http://localhost:8080 -u administrator -p password -m POST /datasource/2617/table/samples_donors/facets/_search --content-type application/json -j < query2/opal-request.json
```

Query criteria: 

```
SampleStatus="Lesional material" and ConsentStatus="Informed consent" and DonorGender="M"
```

Result: 

```
2 Samples, 1 Donors
```
