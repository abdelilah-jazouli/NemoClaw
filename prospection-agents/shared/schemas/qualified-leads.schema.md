# Schema : Leads qualifies

## Fichier de sortie
- Chemin : `/sandbox/shared/exchange/qualified/<campaign-id>.json`
- Producteur : `lead-qualifier`
- Consommateurs : `copywriter`, `prospection-manager`

## Structure JSON

```json
{
  "schema": "qualified-leads",
  "version": "1.0",
  "metadata": {
    "campaignId": "string",
    "createdAt": "string — ISO 8601",
    "source": "lead-qualifier",
    "inputLeads": "number — nombre de leads recus",
    "qualifiedLeads": "number — nombre de leads retenus",
    "scoringCriteria": {
      "minScore": "number — seuil minimum (defaut: 7)",
      "criteria": [
        {
          "name": "string — nom du critere",
          "maxPoints": "number",
          "description": "string"
        }
      ]
    }
  },
  "leads": [
    {
      "id": "string — meme id que dans lead-list",
      "score": "number — 1 a 10",
      "tier": "A | B | C",
      "scoring_breakdown": [
        {
          "criterion": "string — nom du critere",
          "points": "number",
          "justification": "string — fait observable"
        }
      ],
      "recommendation": "string — approche suggeree pour ce lead",
      "priority_contact": "email | linkedin | phone",
      "original_data": "object — copie du lead original (reference)"
    }
  ]
}
```

## Regles de validation
- `score` = somme des `points` dans `scoring_breakdown`
- Chaque `justification` doit etre un fait verifiable, pas une opinion
- `tier` : A = score >= 8, B = score 7, C = score < 7 (rejete)
- Seuls les tiers A et B sont inclus (C mentionnes en metadata)
