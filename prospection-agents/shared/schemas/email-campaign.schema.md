# Schema : Campagne email

## Fichier de sortie
- Chemin : `/sandbox/shared/exchange/campaigns/<campaign-id>.json`
- Producteur : `copywriter`
- Consommateurs : `prospection-manager`

## Structure JSON

```json
{
  "schema": "email-campaign",
  "version": "1.0",
  "metadata": {
    "campaignId": "string",
    "createdAt": "string — ISO 8601",
    "source": "copywriter",
    "totalLeads": "number",
    "totalEmails": "number"
  },
  "sequences": [
    {
      "leadId": "string — reference au lead qualifie",
      "leadName": "string",
      "company": "string",
      "emails": [
        {
          "type": "initial | followup-1 | followup-2",
          "delay": "string — J+0, J+3, J+7",
          "subject": "string — < 50 caracteres",
          "body": "string — < 150 mots",
          "personalization": {
            "recentEvent": "string — fait utilise pour personnaliser",
            "painPoint": "string — pain point adresse",
            "differentiator": "string — argument utilise"
          }
        }
      ]
    }
  ]
}
```

## Regles de validation
- Chaque sequence a exactement 3 emails (initial + 2 relances)
- `subject` < 50 caracteres, pas de spam words
- `body` < 150 mots
- `personalization.recentEvent` doit correspondre au `context.recentEvent` du lead original
