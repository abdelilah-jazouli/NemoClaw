# Schema : Rapport de marche

## Fichier de sortie
- Chemin : `/sandbox/shared/exchange/market-reports/<campaign-id>.json`
- Producteur : `market-analyst`
- Consommateurs : `copywriter`, `prospection-manager`

## Structure JSON

```json
{
  "schema": "market-report",
  "version": "1.0",
  "metadata": {
    "campaignId": "string",
    "createdAt": "string — ISO 8601",
    "sector": "string — secteur analyse",
    "source": "market-analyst"
  },
  "executive_summary": "string — 5 lignes max",
  "market": {
    "size": "string — estimation du marche",
    "growth": "string — taux de croissance",
    "trends": [
      {
        "name": "string",
        "description": "string",
        "source": "string — URL"
      }
    ]
  },
  "competitors": [
    {
      "name": "string",
      "positioning": "string — 1 phrase",
      "strengths": ["string"],
      "weaknesses": ["string"]
    }
  ],
  "differentiators": [
    {
      "angle": "string — argument differenciateur",
      "painPoint": "string — probleme client adresse",
      "proof": "string — chiffre ou cas concret"
    }
  ],
  "buyingSignals": [
    {
      "signal": "string",
      "howToDetect": "string",
      "relevance": "high | medium | low"
    }
  ]
}
```

## Regles de validation
- Chaque `trend` doit avoir une `source` URL
- Au moins 3 `competitors`
- Au moins 3 `differentiators` avec un `proof` factuel
- `executive_summary` < 500 caracteres
