# Schema : Liste de leads

## Fichier de sortie
- Chemin : `/sandbox/shared/exchange/leads/<campaign-id>.json`
- Producteur : `lead-researcher`
- Consommateurs : `lead-qualifier`, `prospection-manager`

## Structure JSON

```json
{
  "schema": "lead-list",
  "version": "1.0",
  "metadata": {
    "campaignId": "string",
    "createdAt": "string — ISO 8601",
    "query": "string — la demande originale",
    "source": "lead-researcher",
    "totalLeads": "number"
  },
  "leads": [
    {
      "id": "string — identifiant unique du lead",
      "firstName": "string",
      "lastName": "string",
      "jobTitle": "string — poste exact",
      "company": {
        "name": "string",
        "sector": "string",
        "size": "string — tranche (1-10, 11-50, 51-200, 201-500, 500+)",
        "location": "string — ville, pays",
        "website": "string — URL ou null"
      },
      "contact": {
        "email": "string — email professionnel ou null si non trouve",
        "emailConfidence": "high | medium | low | unverified",
        "linkedinUrl": "string — URL profil LinkedIn ou null",
        "phone": "string — telephone ou null"
      },
      "context": {
        "recentEvent": "string — fait marquant recent",
        "eventSource": "string — URL de la source",
        "eventDate": "string — date approximative"
      },
      "sources": ["string — URLs des sources utilisees"]
    }
  ]
}
```

## Regles de validation
- `totalLeads` doit correspondre a `leads.length`
- `email` : format valide ou null (jamais invente)
- `emailConfidence` : "high" = trouve sur le site corporate, "medium" = pattern deduction, "low" = annuaire tiers, "unverified" = non confirme
- `sources` : au moins 1 URL par lead (pas d'invention)
- `recentEvent` : doit avoir une `eventSource` URL verifiable
